//
//  SideMenuStyle.swift
//  SUISideMenu
//
//  Created by Moaz Ezz on 10/1/20.
//

import Foundation

/// How the drawer transitions in and out.
public enum SideMenuStyle: Equatable, Hashable, Sendable, CaseIterable {
    /// Menu slides in on top of the main content (main content stays put,
    /// optionally blurred / scaled).
    case slideInOver
    /// Menu and main content slide together (main content is pushed aside).
    case slideInOut
}

@available(
    *, deprecated, renamed: "SideMenuStyle",
    message: "Use SideMenuStyle to avoid clashing with SwiftUI.MenuStyle."
)
public typealias MenuStyle = SideMenuStyle
