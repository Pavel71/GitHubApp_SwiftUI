//
//  DetailViewModel.swift
//  GitHubApp_SwiftUI
//
//  Created by Павел Мишагин on 02.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import Foundation
import Combine


final class DetailViewModel : ObservableObject {
  
  // MARK: -  Input
  @Published var username : String = ""
  
  // MARK: -  Output
  
  @Published var detailModel: DetailModel = DetailModel(
  login     : "--\\--",
  avatarUrl : nil,
  name      : "--\\--",
  createdAt : "--\\--",
  location  : "--\\--")
  
  @Published var repos : [Repository] = []
  
  @Published var alertDataInfo : AlertDataInfo?
  
  
  // MARK: - Publishers
  
//  private var loadUserDetailsPublisher: AnyPublisher<DetailModel,Never> {
//
//  }
  

  
  private var cancellable: Set<AnyCancellable> =  []
  
  // MARK: - Init
  
  init() {
    
    // Теперь задача стоит сделать загрузку репозиториев!
    
    $username
      .filter{$0.isEmpty == false}
      .flatMap { (userName) -> AnyPublisher<DetailModel,Never> in
        guard  userName.isEmpty == false else {
          return Just(self.detailModel).eraseToAnyPublisher()
        }
        let endPoint: Endpoint = .user(userName: userName)
        return GitHubApi.shared.fetchUserDetail(from: endPoint)
          .catch { (error) -> AnyPublisher<DetailModel,Never> in
            print("Ошибка")
            self.alertDataInfo = AlertDataInfo(title: "Ощибка при Загрузке доп пользователей", message: error.localizedDescription)
            return Just(self.detailModel).eraseToAnyPublisher()
        }.eraseToAnyPublisher()

    }.subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink(receiveValue:{ [weak self] in
        print("Пришел результат,",$0)
        self?.detailModel = $0
      }).store(in:&cancellable)
  }
}


extension DetailViewModel {
  
  func loadDetailUser(userName: String) {
    self.username = userName
  }
}
