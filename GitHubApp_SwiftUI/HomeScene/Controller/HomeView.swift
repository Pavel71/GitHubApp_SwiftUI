//
//  HomeView.swift
//  GitHubApp_SwiftUI
//
//  Created by Павел Мишагин on 01.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import SwiftUI

// Нужно попробовать написать сетевой слой с помощью кода генерации- руками)
// Это будет крайне полезный скилл

// Теперь мне нужно добавить Nvigation View - и Detail scren

struct HomeView: View {
  
  @ObservedObject var viewModel  = HomeViewModel()
  
  init() {
    
    if #available(iOS 14.0, *) {
      // iOS 14 doesn't have extra separators below the list by default.
    } else {
      // To remove only extra separators below the list:
      UITableView.appearance().tableFooterView = UIView()
    }
    
    
  }
  
  
  
  var body: some View {
    
    ZStack(alignment: .top) {
      
      VStack {
        SearchBarView(
          text: $viewModel.searchText,
          placeHolder: "Search..")
        
        UserList(viewModel: viewModel)
        
        //        Section(footer:Text("") ) {
        
        
      }
      
    }
  }
  
  
  
  // MARK: - User List
  
  
  struct UserList : View {
    
    @ObservedObject var viewModel : HomeViewModel
    
    @ViewBuilder private func showLoading() -> some View {
      if viewModel.isLoading {
        
        Divider()
        HStack() {
          Spacer()
          Text("Loading...")
          Spacer()
        }
      }
    }
    
    var body: some View {
      
      Section(footer: self.showLoading()) {
        
        List() {  
          
          ForEach(self.viewModel.models) { (model)  in
            UserAccountListCell(model: model)
             .onAppear {self.viewModel.isLastItem = model}
          }
          
//          VStack(alignment: .leading, spacing: 5) {
//            UserAccountListCell(model: model)
//
//          }// Stakc Cell
           
          
          
        }.padding(.vertical)
          .dissmisKeyaboardThanTap()
          .alert(item: $viewModel.alertDataInfo) { (alert) -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: .cancel())
        }
      }// List
    } // Section
    
  }// Body
}

// MARK: - USerAccountListCell
struct UserAccountListCell: View {
  
  var model : GitHubUser
  
  var body: some View {
    
    HStack(spacing:20) {
      
      UserImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: model.avatarUrl))
      
      VStack(alignment: .leading, spacing: 5) {
        Text(model.username).font(.title)
        Text(model.type).font(.subheadline)
      }.font(.title)
    }
    
  }
}



// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
