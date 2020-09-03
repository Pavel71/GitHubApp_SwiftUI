//
//  AnyTranstionExt.swift
//  CustomNavigationView
//
//  Created by exey on 10.03.2020.
//  Copyright © 2020 exey. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading).combined(with: .opacity)
        let removal = AnyTransition.scale.combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
  
  static var push: AnyTransition {
    let insertion = AnyTransition.move(edge: .leading).combined(with: .opacity).combined(with: .opacity)
    return insertion

  }
    
}
