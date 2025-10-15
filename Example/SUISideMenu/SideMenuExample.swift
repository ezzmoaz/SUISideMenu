//
//  ContentView.swift
//  SUISideMenu
//
//  Created by Moaz Ezz on 8/14/20.
//  Copyright © 2020 moazezz. All rights reserved.
//


import SwiftUI
import SUISideMenu



struct SideMenuExample: View {
    @EnvironmentObject var UIState: UIStateModel
    @State var myMenuStyle : SUISideMenu.MenuStyle = .slideInOver
    @State var menuWidthValue : Int = 6
    @State var blurValue : Int = 2
    @State var dimValue : Int = 2
    @State var scaleValue : Int = 10
    var body: some View {
            SideMenu(menuWidth: CGFloat(menuWidthValue)/10,
                     menuStyle: self.myMenuStyle,
                     blur: CGFloat(self.blurValue),
                     scale: CGFloat(scaleValue)/10,
                     dimValue: CGFloat(dimValue)/10,
                     sideMenu: {
                        VStack{
                            Text("SideMenu")
                            Button(action: {
                                self.UIState.toggleMenuScreen()
                            }) {
                                Text("Close Menu")
                                .padding()
                                    .foregroundColor(.black)
                                    .border(Color.black, width: 1)
                                
                            }
                        }
                        .frame( maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.red)
                        .transition(AnyTransition.slide)
                        .animation(.spring())
            }, mainView: {
                VStack{
                    Text("Main")
                    Button(action: {
                        self.UIState.toggleMenuScreen()
                    }) {
                        Text("Open Menu")
                        .padding()
                            .foregroundColor(.black)
                            .border(Color.black, width: 1)
                    }
                    Text("Pick Style")
                    Picker("Pick Style", selection: self.$myMenuStyle) {
                        Text("slideInOver").tag(MenuStyle.slideInOver)
                        Text("slideInOut").tag(MenuStyle.slideInOut)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    VStack{
                        Text("Menu Width")
                        Picker("Scale", selection: self.$menuWidthValue) {
                            Text("0.1").tag(1)
                            Text("0.2").tag(2)
                            Text("0.3").tag(3)
                            Text("0.5").tag(5)
                            Text("0.6").tag(6)
                            Text("0.7").tag(7)
                            Text("0.8").tag(8)
                            Text("0.9").tag(9)
                            Text("1").tag(10)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Text("Blur")
                        Text("Only avalible With slideInOver menu Style.")
                            .font(.caption)
                            .lineLimit(nil)
                        Picker("Blur", selection: self.$blurValue) {
                            Text("0").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("3").tag(3)
                            Text("5").tag(5)
                            Text("6").tag(6)
                            Text("7").tag(7)
                            Text("8").tag(8)
                            Text("9").tag(9)
                            Text("10").tag(10)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Text("Scale")
                        Text("Only avalible With slideInOver menu Style")
                        .font(.caption)
                        .lineLimit(nil)
                        Picker("Scale", selection: self.$scaleValue) {
                            Text("0").tag(0)
                            Text("0.1").tag(1)
                            Text("0.2").tag(2)
                            Text("0.3").tag(3)
                            Text("0.5").tag(5)
                            Text("0.6").tag(6)
                            Text("0.7").tag(7)
                            Text("0.8").tag(8)
                            Text("0.9").tag(9)
                            Text("1").tag(10)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Text("Dim")
                    Picker("Dim", selection: self.$dimValue) {
                        Text("0").tag(0)
                        Text("0.1").tag(1)
                        Text("0.2").tag(2)
                        Text("0.3").tag(3)
                        Text("0.5").tag(5)
                        Text("0.6").tag(6)
                        Text("0.7").tag(7)
                        Text("0.8").tag(8)
                        Text("0.9").tag(9)
                        Text("1").tag(10)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    
                }
            
                .frame( maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(Color.blue)
                .transition(AnyTransition.slide)
                .animation(.spring())
            })
        
    }
    
    
}

struct SideMenuExample_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuExample().environmentObject(UIStateModel())
    }
}
