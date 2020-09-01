//
//  HomeView.swift
//  GitHubApp_SwiftUI
//
//  Created by Павел Мишагин on 01.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import SwiftUI

// SearchBarView
// List accaunt
// Cell

// Нужно добавить пагинацию tableView

struct HomeView: View {
  
  @ObservedObject var viewModel  = HomeViewModel()
  
  
  var body: some View {
    
    ZStack(alignment: .top) {
      
      VStack {
        SearchBarView(text: $viewModel.searchText, placeHolder: "Search..")
        
        List(viewModel.models, id: \.self) { model in
          UserAccountListCell(model: model)
        }
        
      }.padding(.vertical)
        .dissmisKeyaboardThanTap()
        .alert(item: $viewModel.alertDataInfo) { (alert) -> Alert in
          Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: .cancel())
      }
      
    }
    
  }
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
