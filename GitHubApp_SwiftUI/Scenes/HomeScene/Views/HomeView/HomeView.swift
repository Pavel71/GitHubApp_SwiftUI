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
    
    NavControllerView(transition: .custom(AnyTransition.push)) {
      ZStack(alignment: .top) {

        VStack {
          SearchBarView(
            text: self.$viewModel.searchText,
            placeHolder: "Search..")
         
          UserList(viewModel: self.viewModel)
         
          
         }// Generall Vstack
        
      }// Zstack
    }

    
 
  }
  
  
  
  // MARK: - User List
  
  
  struct UserList : View {
    
    @ObservedObject var viewModel : HomeViewModel
    
//    @State var didTapCell = false
    
    @ViewBuilder private var  showLoading : some View {
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
      
      
        Section(footer: self.showLoading) {
          
          List(viewModel.models,id:\.self) { model in
            
            NavPushButton(destination: DetailsView(userName: model.username)) {
              UserAccountListCell(model: model)
              .onAppear {self.viewModel.isLastItem = model}
            }

            
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
