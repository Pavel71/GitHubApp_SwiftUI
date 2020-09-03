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
  
  private var sustemBackgroundColor: some View {
    Color.init(UIColor(named: "systemBackground")!)
  }
  
  
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
      
    }.frame(height: 52)
      .background(sustemBackgroundColor)
    
  }
  
  // MARK: Header
  private var header: some View {
    
    return VStack(alignment: .leading) {
      HStack(spacing:20) {
        // Image
        if viewModel.detailModel.avatarUrl == nil {
          Image(systemName: "person")
            .resizable()
            .foregroundColor(Color.secondary)
            .frame(width: 120, height: 120)
        } else {
          UserImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: viewModel.detailModel.avatarUrl!))
        }
        
        VStack(alignment: .leading, spacing: 30) {
          Text("Login: ").font(.headline) +
            Text(viewModel.detailModel.login)
          Text("Name: ").font(.headline) +
            Text(viewModel.detailModel.name ?? "--\\--")
        }
        Spacer()
      }.padding(.horizontal)
        .padding(.vertical,4)
      
      HStack {
        VStack(alignment: .leading,spacing:10) {
          Text("Creatred At: ").font(.headline) +
            Text(viewModel.detailModel.createdAt)
          Text("Location: ").font(.headline) +
            Text(viewModel.detailModel.location ?? "--\\--")
        }
      }.padding(.horizontal)
      
    } // General VStack
      .frame(maxWidth: .infinity)
      .background(sustemBackgroundColor)
  }
  
  
  
  // MARK: - Init
  @ObservedObject var viewModel =  DetailViewModel()
  
  private var userName : String = ""
  
  init(userName: String) {
    
    self.userName = userName
    
  }
  
  
  // MARK: Body
  var body: some View {
    
    
    ZStack(alignment: .top) {
      
      Color.init(UIColor(named: "systemBackground")!).edgesIgnoringSafeArea(.top)
        .frame(height: 2)
      
      VStack(spacing:0) {
        navBar
        header
        ListRepos(models: viewModel.repos)
        
      }
      .onAppear{
        print("Загрузился экран")
        self.loadUserDetail()
        
      }// Vstack
         .alert(item: $viewModel.alertDataInfo) { (alert) -> Alert in
                     Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: .cancel())
                }
      
    }// Zstack
  }
  
  // MARK: - LoadModel
  
  private func loadUserDetail() {
    viewModel.loadDetailUser(userName: userName)
  }
}



// MARK: - List Repos

struct ListRepos : View {
  
  var models : [Repository] = [
    Repository(name: "Pavel", language: "Swift",  updatedAt: "10-09-20", stars: 25)
  ]
  
  private var reposHeader : some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Repositories")
          .font(.headline)
        Spacer()
      }.padding()
    }
  }
  
  var body: some View {
    Section(header: reposHeader) {
      List(models,id: \.self) { model in
        RepoCell(model:model)
        
      }
    }
    
  }
}

// MARK: Repo Cell
struct RepoCell : View {
  var model : Repository
  
  @State var isNeedMoreInfo = false
  
  var body: some View {
    
    HStack {
      
      VStack(alignment: .leading, spacing: 10) {
        Text("Name: ").font(.headline) +
        Text(model.name)
        Text("Language: ").font(.headline) +
        Text(model.language ?? "--\\--")
        
        if self.isNeedMoreInfo {

          Text("Updated: ").font(.headline) +
          Text(model.updatedAt)
          Text("Stars: ").font(.headline) +
          Text("\(model.stars)")
 
            }
      }
      Spacer()
      Button(action: {
        withAnimation { ()  in
          self.isNeedMoreInfo.toggle()
        }
      }) {
        Text("More Info")
          .foregroundColor(.blue)
      }
      
    }.padding(.vertical)// HStack
    
  }
}


struct DetailsView_Previews: PreviewProvider {
  static var previews: some View {
    DetailsView(userName: "")
  }
}
