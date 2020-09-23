//
//  UIStateModel.swift
//  SUISideMenu
//
//  Created by Moaz Ezz on 9/20/20.
//  Copyright © 2020 moazezz. All rights reserved.
//

import SwiftUI

public class UIStateModel: ObservableObject {
    @Published var activeScreen: Screens = .other
    @Published var screenDrag: Float = 0.0
    
    public init() {}
    
    public enum Screens {
        case menu
        case other
    }
    
    public func toggleMenuScreen(){
        self.activeScreen = (self.activeScreen == .menu) ? .other : .menu
    }
    
    public func getScale(minScale:CGFloat) -> CGFloat{
        
        let fullWdith = UIScreen.main.bounds.width*4
        let currentWidth = self.screenDrag
        
        let defaultScale: CGFloat = 1
        let minScale: CGFloat = minScale
        
        let currentValueOfScale = CGFloat(currentWidth)*defaultScale/fullWdith
        if currentValueOfScale == 0{
            return activeScreen == .menu ? minScale : defaultScale
        }
        if self.activeScreen ==  .menu {
            if self.screenDrag > 0{
                return minScale
            }else{
                let x = minScale + abs(currentValueOfScale)
                return x > defaultScale ? defaultScale : x
            }
        }else{
            if self.screenDrag > 0{//To menu
                let x = defaultScale - abs(currentValueOfScale)
                return x < minScale ? minScale : x
            }else{
                return defaultScale
            }
        }
    }
    
    public func getBlur(maxValue: CGFloat) -> CGFloat{
        
        let fullWdith = UIScreen.main.bounds.width/4
        let currentWidth = self.screenDrag
        
        let maxBlur: CGFloat = maxValue
        let minBlur: CGFloat = 0
        
        let currentValueOfBlur = CGFloat(currentWidth)*maxValue/fullWdith
        if currentValueOfBlur == 0{
            return activeScreen == .menu ? maxBlur : minBlur
        }
        if self.activeScreen ==  .menu {
            if self.screenDrag > 0{
                return maxBlur
            }else{
                let x = maxBlur - abs(currentValueOfBlur)
                return x < minBlur ? minBlur : x
            }
        }else{
            if self.screenDrag > 0{//To menu
                let x = minBlur + abs(currentValueOfBlur)
                return x > maxBlur ? maxBlur : x
            }else{
                return minBlur
            }
        }
        //        return 1
    }
    
}
