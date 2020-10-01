//
//  ContentView.swift
//  SUISideMenu Test
//
//  Created by Moaz Ezz on 10/1/20.
//

import SwiftUI
import SUISideMenu

struct ContentView: View {
    var body: some View {
        SideMenu {
            Text("SideMEnu")
        } mainView: {
            Text("manView")
        }
        .environmentObject(UIStateModel())

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
