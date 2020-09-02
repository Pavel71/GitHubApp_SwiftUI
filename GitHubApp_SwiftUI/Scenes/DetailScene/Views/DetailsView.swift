//
//  DetailsView.swift
//  GitHubApp_SwiftUI
//
//  Created by Павел Мишагин on 02.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import SwiftUI

struct DetailsView: View {
  
  // MARK: Views
  
  
  
  // MARK: Back Button
  private var backButton:some View {
    NavPopButton(destination: .previous) {
      Image(systemName: "arrow.left.square")
        .foregroundColor(.blue)
        .font(.title)
    }
  }
  
  // MARK: NAvBar
  private var navBar: some View {
    VStack {
      HStack {
        backButton
        Spacer()
        Text("Detail Screen")
          .font(.headline)
        Spacer()
        Text("")
      }.padding()
      Divider()
    }.frame(height: 52)
  }
  
  
  private var header: some View {
    Text("Header")
  }
  
  
  // MARK: Body
    var body: some View {
      VStack {
        
        navBar
        Spacer()
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Spacer()
      }
        
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}
