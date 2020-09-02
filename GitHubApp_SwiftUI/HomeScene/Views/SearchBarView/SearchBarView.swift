//
//  SearchBarView.swift
//  SwiftUIHelpsProject
//
//  Created by Павел Мишагин on 01.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {
  
  @Binding var text : String
  var placeHolder   : String
  
    var body: some View {
      
     HStack {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.secondary).font(.title)
        TextField(placeHolder, text: $text)
        
        Button(action: {
          print("Delete text")
          self.text = ""
        }) {
          Image(systemName: "xmark.circle")
            .foregroundColor(.secondary).font(.title)
        }
         
      }
      .padding()
      .overlay(
        RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1)
      )
     .padding(.horizontal)
        
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
      SearchBarView(text: .constant(""), placeHolder: "Search...")
    }
}
