//
//  SideMenu.swift
//  SUISideMenu
//
//  Created by Moaz Ezz on 9/20/20.
//  Copyright © 2020 moazezz. All rights reserved.
//

import SwiftUI


public struct SideMenu<SideMenu : View, MainView : View> : View {
    public let sideMenu: SideMenu
    public let mainView: MainView
    public let menuWidth: CGFloat // Precentage of the full Screen
    public let menuStyle : MenuStyle
    public let blur: CGFloat
    public let scale: CGFloat
    public let dimValue: CGFloat
    
    @GestureState var isDetectingLongPress = false
    
    @EnvironmentObject var UIState: UIStateModel
    
    @State var orientation = UIDevice.current.orientation
    @State var isLoading = false
       let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
           .makeConnectable()
           .autoconnect()
    
    @inlinable public init(
        menuWidth: CGFloat = 0.6,
        menuStyle: MenuStyle = .slideInOver,
        blur: CGFloat = 2,
        scale: CGFloat = 1,
        dimValue: CGFloat = 0.2,
        @ViewBuilder sideMenu: () -> SideMenu,
                     @ViewBuilder mainView: () -> MainView) {
        self.sideMenu = sideMenu()
        self.mainView = mainView()
        self.menuWidth = menuWidth > 1 ? 1 : menuWidth
        self.menuStyle = menuStyle
        self.blur = blur
        self.scale = scale > 1 ? 1 : scale
        self.dimValue = dimValue > 1 ? 1 : (dimValue < 0.01) ? 0.01 : dimValue
    }
    
    public var body: some View {
        let cardWidth =  UIScreen.main.bounds.width
        
        var xOffsetToShift : CGFloat = cardWidth * (self.menuWidth/2)
        if menuStyle == MenuStyle.slideInOver{
            xOffsetToShift = -cardWidth * ((1 - self.menuWidth)/2)
        }
//        if orientation == .landscapeLeft || orientation == .landscapeRight{
//                   xOffsetToShift += 500
//               }
        let totalMovement = cardWidth
        let activeOffset = xOffsetToShift - (totalMovement * CGFloat(UIState.activeScreen == UIStateModel.Screens.menu ? 0 : self.menuWidth))
        let nextOffset = xOffsetToShift - (totalMovement * CGFloat(UIState.activeScreen == UIStateModel.Screens.menu ? self.menuWidth : 0))
        
        var calcOffset = Float(activeOffset)
        
        if (calcOffset != Float(nextOffset)) {
            calcOffset = Float(activeOffset) + UIState.screenDrag
        }
       
        
        return HStack (spacing: 0){
            if self.orientation != .unknown{
            if self.menuStyle == .slideInOver{//slideInOver
                ZStack{
                    mainView
                        .blur(radius: UIState.getBlur(maxValue: self.blur))
                        .scaleEffect( UIState.getScale(minScale: self.scale))
                        .frame(width: cardWidth)
                    VStack{
                        Text("")
                            .frame(maxWidth: .infinity,  maxHeight: .infinity)
                    }
                    .background(Color.clear)
                    .overlay(Color.black.opacity(Double(UIState.getBlur(maxValue: self.dimValue))))
//                    .frame(width: cardWidth, height: UIScreen.main.bounds.height)
                    .onTapGesture {
                        if self.UIState.activeScreen == .menu{
                            self.UIState.toggleMenuScreen()
                        }
                    }
                    sideMenu
                        .frame(width: self.menuWidth * cardWidth)
                        .offset(x: CGFloat(calcOffset), y: 0)
                }
                .animation(.spring())
                
            }else{
                sideMenu
                    .frame(width: self.menuWidth * cardWidth)
                    .offset(x: CGFloat(calcOffset), y: 0)
                ZStack{
                    
                    mainView
                        
                        .frame(width: cardWidth)
                        .offset(x: CGFloat(calcOffset), y: 0)
                    VStack{
                        Text("")
                            .frame(maxWidth: .infinity,  maxHeight: .infinity)
                    }
                        
                    .background(Color.clear)
                    .overlay(Color.black.opacity(Double(UIState.getBlur(maxValue: self.dimValue))))
                    .animation(.spring())
                    .frame(width: cardWidth)
                    .offset(x: CGFloat(calcOffset), y: 0)
                    .onTapGesture {
                        if self.UIState.activeScreen == .menu{
                            self.UIState.toggleMenuScreen()
                        }
                    }
                }
                
            }
        }
            
        }
        .edgesIgnoringSafeArea([.top, .bottom])
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
            if abs(currentState.translation.width) > totalMovement * self.menuWidth{
                return
            }
            if self.UIState.activeScreen == .other && Float(currentState.translation.width) < 0{
                return
            }
            if self.UIState.activeScreen == .menu && Float(currentState.translation.width) > 0{
                self.UIState.screenDrag = 2 //To have a little pounce when dragging in Menu Direction
                return
            }
            self.UIState.screenDrag = Float(currentState.translation.width)
            
        }.onEnded { value in
            self.UIState.screenDrag = 0
            if (value.translation.width < -50) {
                self.UIState.activeScreen = .other
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
            if (value.translation.width > 50) {
                self.UIState.activeScreen = .menu
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
        })
        .onReceive(orientationChanged) { newVal in
            self.orientation = (UIDevice.current.orientation.rawValue == 0) ? .portraitUpsideDown : UIDevice.current.orientation

        }
            
    }
}


public enum MenuStyle: Equatable {
    case slideInOver
    case slideInOut
}
