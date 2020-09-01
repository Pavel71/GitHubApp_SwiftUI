//
//  DismissKeyboard+ Extension.swift
//  GitHubApp_SwiftUI
//
//  Created by Павел Мишагин on 01.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import SwiftUI
extension View {
  func dissmisKeyaboardThanTap() -> some View {
    self.modifier(DismissingKeyboard())
  }
}
struct DismissingKeyboard: ViewModifier {
  func body(content: Content) -> some View {
    content
      .onTapGesture {
        let keyWindow = UIApplication.shared.connectedScenes
          .filter({$0.activationState == .foregroundActive})
          .map({$0 as? UIWindowScene})
          .compactMap({$0})
          .first?.windows
          .filter({$0.isKeyWindow}).first
        keyWindow?.endEditing(true)
    }
  }
}
