//
//  DetailViewModel.swift
//  GitHubApp_SwiftUI
//
//  Created by Павел Мишагин on 02.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import Foundation
import Combine
import SwiftUI


final class DetailViewModel : ObservableObject {
  
  // MARK: -  Input
  @Published var username : String = ""
  
  // MARK: -  Output
  
  @Published var detailModel: DetailModel = DetailModel(
  login     : "",
  avatarUrl : nil,
  name      : "",
  createdAt : "",
  location  : "")
  
  @Published var repos : [Repository] = []
  @Published var alertDataInfo : AlertDataInfo?
  @Published var isLoading     = false
  
  
  // MARK: - Publishers
  
  private func loadUserDetailsPublisher(username: String) -> AnyPublisher<DetailModel,Never> {
 print("Пошла загрузка Details")
    let endPoint: Endpoint = .user(userName: username)
    
    return GitHubApi.shared.fetchUserDetail(from: endPoint)
      .catch { (error) -> AnyPublisher<DetailModel,Never> in
        print("Ошибка User Detail")
        self.alertDataInfo = AlertDataInfo(title: "Ощибка при Загрузке доп пользователей", message: error.localizedDescription)
        return Just(self.detailModel).eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }
  
  
  private func loadUserReposPublisher(username: String) -> AnyPublisher<[Repository],Never> {
    print("Пошла загрузка Repos")
    let endPoint: Endpoint = .repos(userName: username)

    return GitHubApi.shared.fetchUserRepos(from: endPoint)
      .catch { (error) -> AnyPublisher<[Repository],Never> in
        print("Ошибка Repos")
        self.alertDataInfo = AlertDataInfo(title: "Ощибка при Загрузке доп пользователей", message: error.localizedDescription)
        return Just([]).eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }
  
  private func combineAsynLoadTwoRequest(username: String) -> AnyPublisher<(DetailModel, [Repository]),Never> {
    
    Publishers.CombineLatest(loadUserDetailsPublisher(username: username), loadUserReposPublisher(username: username)).eraseToAnyPublisher()

  }

  
  private var cancellable: Set<AnyCancellable> =  []
  
  // MARK: - Init
  
  init() {
    
    $username
         .filter{$0.isEmpty == false}
         .flatMap { (userName) -> AnyPublisher<(DetailModel, [Repository]),Never> in
         
           return self.combineAsynLoadTwoRequest(username: userName)
       }.subscribe(on: DispatchQueue.global())
         .receive(on: DispatchQueue.main)
         .sink { (detailModel,repos) in
           print("Пришли repos,и  DetailModel")
          
          withAnimation(Animation.easeOut(duration: 0.5)) {
             
             self.detailModel = detailModel
             self.repos       = repos
             self.isLoading   = false
           }
           
          
       }.store(in: &cancellable)
    
    
    
    
    
    
   

    
    
   
  }
}


extension DetailViewModel {
  
  func loadDetailUser(userName: String) {
    self.isLoading = true
    self.username = userName
  }
}
