//
//  SideMenuExample.swift
//  SUISideMenuExample
//
//  Created by Moaz Ezz on 16/10/2025.
//

import SwiftUI
import SUISideMenu

/// Demo screen: a `SideMenu` whose main content lets you tweak every option
/// live. Slider-equivalent values are kept as "tenths" (`Int` 0...10) so the
/// segmented pickers stay readable.
struct SideMenuExample: View {
    @State private var isOpen = false
    @State private var style: SideMenuStyle = .slideInOver
    @State private var menuWidth = 6   // 0.6
    @State private var blur = 2
    @State private var scale = 10      // 1.0
    @State private var dim = 2         // 0.2
    @State private var adaptive = true

    var body: some View {
        SideMenu(
            isOpen: $isOpen,
            menuWidth: CGFloat(menuWidth) / 10,
            menuStyle: style,
            blur: CGFloat(blur),
            scale: CGFloat(scale) / 10,
            dimValue: CGFloat(dim) / 10,
            adaptive: adaptive,
            sideMenu: {
                MenuPanel(isOpen: $isOpen)
            },
            mainView: {
                ControlsPanel(
                    isOpen: $isOpen,
                    style: $style,
                    menuWidth: $menuWidth,
                    blur: $blur,
                    scale: $scale,
                    dim: $dim,
                    adaptive: $adaptive
                )
            }
        )
    }
}

// MARK: - Menu panel

private struct MenuPanel: View {
    @Binding var isOpen: Bool

    var body: some View {
        VStack(spacing: 16) {
            Text("SideMenu")
                .font(.title3.bold())

            Button("Close Menu") {
                withAnimation { isOpen = false }
            }
            .buttonStyle(.bordered)
            .tint(.white)

            Spacer()
        }
        .padding(.top, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .background(Color.red)
    }
}

// MARK: - Controls panel

private struct ControlsPanel: View {
    @Binding var isOpen: Bool
    @Binding var style: SideMenuStyle
    @Binding var menuWidth: Int
    @Binding var blur: Int
    @Binding var scale: Int
    @Binding var dim: Int
    @Binding var adaptive: Bool

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// `menuWidth` is ignored only when the split view is actually active —
    /// i.e. adaptive is on AND we're in a regular size class (iPad). On
    /// iPhone it's still a drawer that uses `menuWidth`.
    private var usesSplitView: Bool {
        adaptive && horizontalSizeClass == .regular
    }

    private static let tenths: [StepPicker.Option] =
        [(0, "0"), (1, "0.1"), (2, "0.2"), (3, "0.3"), (5, "0.5"),
         (6, "0.6"), (7, "0.7"), (8, "0.8"), (9, "0.9"), (10, "1")]

    private static let blurSteps: [StepPicker.Option] =
        [(0, "0"), (2, "2"), (3, "3"), (5, "5"), (6, "6"), (7, "7"), (8, "8"), (9, "9"), (10, "10")]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Picker("Style", selection: $style) {
                        Text("slideInOver").tag(SideMenuStyle.slideInOver)
                        Text("slideInOut").tag(SideMenuStyle.slideInOut)
                    }
                    .pickerStyle(.segmented)

                    StepPicker(
                        title: "Menu width",
                        caption: usesSplitView ? "Set by the split view on iPad" : nil,
                        value: $menuWidth,
                        options: Self.tenths
                    )
                    .disabled(usesSplitView)

                    StepPicker(title: "Blur", caption: "slideInOver only", value: $blur, options: Self.blurSteps)
                    StepPicker(title: "Scale", caption: "slideInOver only", value: $scale, options: Self.tenths)
                    StepPicker(title: "Dim", value: $dim, options: Self.tenths)

                    // The adaptive flag only has a visible effect on a regular
                    // size class, so only surface the toggle there.
                    if horizontalSizeClass == .regular {
                        Toggle("Adaptive (split view)", isOn: $adaptive)
                            .font(.subheadline.weight(.semibold))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.blue.opacity(0.08))
            .navigationTitle("SUISideMenu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation { isOpen = true }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
        }
    }
}

// MARK: - Reusable labelled segmented picker

private struct StepPicker: View {
    typealias Option = (tag: Int, label: String)

    let title: String
    var caption: String? = nil
    @Binding var value: Int
    let options: [Option]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline.weight(.semibold))
            if let caption {
                Text(caption)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Picker(title, selection: $value) {
                ForEach(options, id: \.tag) { option in
                    Text(option.label).tag(option.tag)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

#Preview {
    SideMenuExample()
}
