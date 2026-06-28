//
//  SideMenuMath.swift
//  SUISideMenu
//
//  Pure, deterministic geometry/gesture math. Kept free of SwiftUI so it can
//  be unit-tested directly without a view host. `SideMenuDrawer` is a thin
//  rendering layer over these functions.
//

import CoreGraphics

enum SideMenuMath {

    /// Layout sign for the current direction. `+1` for LTR (menu on the
    /// leading/left edge), `-1` for RTL (menu on the trailing/right edge).
    static func sign(isRTL: Bool) -> CGFloat {
        isRTL ? -1 : 1
    }

    /// Open progress in `0...1`, combining the committed state (`isOpen`) with
    /// the live drag. `0` = fully closed, `1` = fully open.
    static func progress(
        isOpen: Bool,
        dragTranslation: CGFloat,
        menuPx: CGFloat,
        sign: CGFloat
    ) -> CGFloat {
        guard menuPx > 0 else { return 0 }
        let base: CGFloat = isOpen ? 1 : 0
        let dragProgress = (dragTranslation * sign) / menuPx
        return min(max(base + dragProgress, 0), 1)
    }

    /// Clamp a raw horizontal drag so it can only move toward the valid
    /// direction (opening when closed, closing when open) and never past the
    /// menu width. Returned value is in screen space (already multiplied by
    /// `sign`), ready to store as `dragTranslation`.
    static func clampedDrag(
        isOpen: Bool,
        rawTranslationWidth: CGFloat,
        menuPx: CGFloat,
        sign: CGFloat
    ) -> CGFloat {
        let opening = rawTranslationWidth * sign
        let limited: CGFloat =
            isOpen
            ? min(max(opening, -menuPx), 0)
            : min(max(opening, 0), menuPx)
        return limited * sign
    }

    /// Decide the resting state when a drag ends, using the predicted
    /// (velocity-projected) translation against a half-width threshold.
    static func willOpen(
        isOpen: Bool,
        predictedTranslationWidth: CGFloat,
        menuPx: CGFloat,
        sign: CGFloat
    ) -> Bool {
        let predicted = predictedTranslationWidth * sign
        let threshold = menuPx / 2
        return isOpen ? predicted > -threshold : predicted > threshold
    }

    /// Leading-edge horizontal offset for the menu panel at a given progress.
    static func menuOffsetX(
        progress: CGFloat,
        menuPx: CGFloat,
        containerWidth: CGFloat,
        sign: CGFloat
    ) -> CGFloat {
        let closed = sign > 0 ? -menuPx : containerWidth
        let open = sign > 0 ? 0 : containerWidth - menuPx
        return closed + (open - closed) * progress
    }

    /// Horizontal shift applied to the main content in `.slideInOut` style.
    static func mainShiftX(
        progress: CGFloat,
        menuPx: CGFloat,
        sign: CGFloat
    ) -> CGFloat {
        (sign > 0 ? menuPx : -menuPx) * progress
    }
}
