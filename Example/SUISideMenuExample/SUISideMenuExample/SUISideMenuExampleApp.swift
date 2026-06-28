//
//  SUISideMenuExampleApp.swift
//  SUISideMenuExample
//
//  Created by Moaz Ezz on 16/10/2025.
//

import SwiftUI

@main
struct SUISideMenuExampleApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                SideMenuExample()
                    .tabItem { Label("Config", systemImage: "slider.horizontal.3") }

                NavigationExample()
                    .tabItem { Label("Navigation", systemImage: "rectangle.stack") }
            }
        }
    }
}
