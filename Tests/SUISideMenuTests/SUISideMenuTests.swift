import SwiftUI
import XCTest

@testable import SUISideMenu

final class SideMenuConfigurationTests: XCTestCase {

    func testClampsMenuWidth() {
        XCTAssertEqual(SideMenuConfiguration(menuWidth: 1.5).menuWidth, 1)
        XCTAssertEqual(SideMenuConfiguration(menuWidth: -0.5).menuWidth, 0.1)
        XCTAssertEqual(SideMenuConfiguration(menuWidth: 0.4).menuWidth, 0.4)
    }

    func testClampsScaleAndDim() {
        let high = SideMenuConfiguration(scale: 2, dimValue: 1.5)
        XCTAssertEqual(high.scale, 1)
        XCTAssertEqual(high.dimValue, 1)

        let low = SideMenuConfiguration(scale: -1, dimValue: -1)
        XCTAssertEqual(low.scale, 0.1)
        XCTAssertEqual(low.dimValue, 0)
    }

    func testBlurClampsAtZeroOnly() {
        XCTAssertEqual(SideMenuConfiguration(blur: 12).blur, 12)
        XCTAssertEqual(SideMenuConfiguration(blur: -3).blur, 0)
    }

    func testEdgeSwipeWidthGovernsSwipeEnabled() {
        XCTAssertTrue(SideMenuConfiguration(edgeSwipeWidth: 24).isSwipeEnabled)
        XCTAssertFalse(SideMenuConfiguration(edgeSwipeWidth: 0).isSwipeEnabled)
        XCTAssertFalse(SideMenuConfiguration(edgeSwipeWidth: -5).isSwipeEnabled)  // clamped to 0
    }

    func testAdaptiveDefaultsOff() {
        XCTAssertFalse(SideMenuConfiguration().adaptive)
        XCTAssertTrue(SideMenuConfiguration(adaptive: true).adaptive)
    }

    @MainActor
    func testFlatInitBuildsClampedConfig() {
        let menu = SideMenu(
            isOpen: .constant(false),
            menuWidth: 5,
            edgeSwipeWidth: 0,
            sideMenu: { Color.red },
            mainView: { Color.blue }
        )
        XCTAssertEqual(menu.configForTesting.menuWidth, 1)
        XCTAssertFalse(menu.configForTesting.isSwipeEnabled)
    }
}

final class SideMenuStyleTests: XCTestCase {

    func testCaseIterable() {
        XCTAssertEqual(SideMenuStyle.allCases.count, 2)
        XCTAssertTrue(SideMenuStyle.allCases.contains(.slideInOver))
        XCTAssertTrue(SideMenuStyle.allCases.contains(.slideInOut))
    }
}

final class SideMenuMathTests: XCTestCase {

    func testSign() {
        XCTAssertEqual(SideMenuMath.sign(isRTL: false), 1)
        XCTAssertEqual(SideMenuMath.sign(isRTL: true), -1)
    }

    func testProgressClosedAndOpen() {
        XCTAssertEqual(SideMenuMath.progress(isOpen: false, dragTranslation: 0, menuPx: 200, sign: 1), 0)
        XCTAssertEqual(SideMenuMath.progress(isOpen: true, dragTranslation: 0, menuPx: 200, sign: 1), 1)
    }

    func testProgressWithDrag() {
        // Closed, dragged half the menu width open → 0.5
        XCTAssertEqual(
            SideMenuMath.progress(isOpen: false, dragTranslation: 100, menuPx: 200, sign: 1),
            0.5, accuracy: 0.0001
        )
        // Open, dragged half the width closed → 0.5
        XCTAssertEqual(
            SideMenuMath.progress(isOpen: true, dragTranslation: -100, menuPx: 200, sign: 1),
            0.5, accuracy: 0.0001
        )
    }

    func testProgressClampsTo0And1() {
        XCTAssertEqual(SideMenuMath.progress(isOpen: false, dragTranslation: 9999, menuPx: 200, sign: 1), 1)
        XCTAssertEqual(SideMenuMath.progress(isOpen: true, dragTranslation: -9999, menuPx: 200, sign: 1), 0)
    }

    func testProgressZeroMenuWidth() {
        XCTAssertEqual(SideMenuMath.progress(isOpen: true, dragTranslation: 50, menuPx: 0, sign: 1), 0)
    }

    func testProgressRTL() {
        // RTL: dragging left (negative width) opens the menu.
        XCTAssertEqual(
            SideMenuMath.progress(isOpen: false, dragTranslation: -100, menuPx: 200, sign: -1),
            0.5, accuracy: 0.0001
        )
    }

    func testClampedDragClosedOnlyOpensForward() {
        // Closed LTR: positive drag allowed up to menuPx, negative ignored.
        XCTAssertEqual(
            SideMenuMath.clampedDrag(isOpen: false, rawTranslationWidth: 150, menuPx: 200, sign: 1), 150)
        XCTAssertEqual(
            SideMenuMath.clampedDrag(isOpen: false, rawTranslationWidth: 999, menuPx: 200, sign: 1), 200)
        XCTAssertEqual(
            SideMenuMath.clampedDrag(isOpen: false, rawTranslationWidth: -50, menuPx: 200, sign: 1), 0)
    }

    func testClampedDragOpenOnlyClosesBackward() {
        // Open LTR: negative drag allowed down to -menuPx, positive ignored.
        XCTAssertEqual(
            SideMenuMath.clampedDrag(isOpen: true, rawTranslationWidth: -150, menuPx: 200, sign: 1), -150)
        XCTAssertEqual(
            SideMenuMath.clampedDrag(isOpen: true, rawTranslationWidth: -999, menuPx: 200, sign: 1), -200)
        XCTAssertEqual(
            SideMenuMath.clampedDrag(isOpen: true, rawTranslationWidth: 50, menuPx: 200, sign: 1), 0)
    }

    func testWillOpenFromClosed() {
        // Past half width → opens
        XCTAssertTrue(
            SideMenuMath.willOpen(isOpen: false, predictedTranslationWidth: 120, menuPx: 200, sign: 1))
        // Short of half width → stays closed
        XCTAssertFalse(
            SideMenuMath.willOpen(isOpen: false, predictedTranslationWidth: 80, menuPx: 200, sign: 1))
    }

    func testWillOpenFromOpen() {
        // Small negative → stays open
        XCTAssertTrue(
            SideMenuMath.willOpen(isOpen: true, predictedTranslationWidth: -80, menuPx: 200, sign: 1))
        // Big negative → closes
        XCTAssertFalse(
            SideMenuMath.willOpen(isOpen: true, predictedTranslationWidth: -120, menuPx: 200, sign: 1))
    }

    func testMenuOffsetX_LTR() {
        // Closed: off-screen to the left (-menuPx). Open: 0.
        XCTAssertEqual(SideMenuMath.menuOffsetX(progress: 0, menuPx: 200, containerWidth: 400, sign: 1), -200)
        XCTAssertEqual(SideMenuMath.menuOffsetX(progress: 1, menuPx: 200, containerWidth: 400, sign: 1), 0)
        XCTAssertEqual(
            SideMenuMath.menuOffsetX(progress: 0.5, menuPx: 200, containerWidth: 400, sign: 1), -100)
    }

    func testMenuOffsetX_RTL() {
        // Closed: off-screen to the right (containerWidth). Open: containerWidth - menuPx.
        XCTAssertEqual(SideMenuMath.menuOffsetX(progress: 0, menuPx: 200, containerWidth: 400, sign: -1), 400)
        XCTAssertEqual(SideMenuMath.menuOffsetX(progress: 1, menuPx: 200, containerWidth: 400, sign: -1), 200)
    }

    func testMainShiftX() {
        XCTAssertEqual(SideMenuMath.mainShiftX(progress: 1, menuPx: 200, sign: 1), 200)
        XCTAssertEqual(SideMenuMath.mainShiftX(progress: 1, menuPx: 200, sign: -1), -200)
        XCTAssertEqual(SideMenuMath.mainShiftX(progress: 0, menuPx: 200, sign: 1), 0)
    }
}
