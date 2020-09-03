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
  @State var isSearching = false
  var placeHolder   : String
  
  // MARK: - Views
  
  private var textField : some View {
    TextField(placeHolder, text: $text)
    .frame(height: 52)
  }
  
  private var clearButton : some View {
    Button(action: {
         print("Delete text")
         self.text = ""
       }) {
         Image(systemName: "xmark.circle")
           .foregroundColor(.secondary).font(.title)
       }
  }
  
  
  
  
  // MARK: - Body
    var body: some View {
      
      HStack {
        
        HStack {
          
          Image(systemName: "magnifyingglass")
            .foregroundColor(.secondary).font(.title)
          textField
          
          if isSearching {
            clearButton
              .transition(.opacity)
              .animation(Animation.easeOut.delay(0.9))
          }
          
        }.padding(.horizontal)
      
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray, lineWidth: 1)
            
        ).onTapGesture {
          self.isSearching = true
        }.padding(.horizontal)
        .transition(.move(edge: .trailing))
        .animation(.easeOut)
         
        if isSearching {
          Button("Cancel") {
            self.text        = ""
            self.isSearching = false
            self.hideKeyboard()
          }.padding(.trailing)
           .padding(.leading,-10)
            .transition(.move(edge: .trailing))
            .animation(.easeOut)
        }
        
      }
     
        
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
      SearchBarView(text: .constant(""), placeHolder: "Search...")
    }
}
