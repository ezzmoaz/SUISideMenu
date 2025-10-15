//
//  SUISideMenuExampleApp.swift
//  SUISideMenuExample
//
//  Created by Moaz Ezz on 16/10/2025.
//

import SwiftUI
import SUISideMenu

@main
struct SUISideMenuExampleApp: App {
    var body: some Scene {
        WindowGroup {
            SideMenuExample().environmentObject(UIStateModel())
        }
    }
}
