//
//  HomeViewModel.swift
//  GitHubApp_SwiftUI
//
//  Created by Павел Мишагин on 01.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import SwiftUI
import Combine

/// View modle get data from Api

final class HomeViewModel : ObservableObject {
  
  // Нужно реализовать несколько паблишеров и
  // 1. Ассинхронную загрузку картинок по URL
  // 2. Загрузка данных по поиску
  
  
  // Input
  
  @Published var searchText    : String = ""
  
  // Output
  @Published var models        : [GitHubUser] = []
  @Published var alertDataInfo : AlertDataInfo?
  
  private var isSearchTextEmpty : AnyPublisher<Bool,Never> {
     
     $searchText
       .debounce(for: 0.5, scheduler: RunLoop.main)
       .removeDuplicates()
       .map {
         $0.isEmpty
      }
      .eraseToAnyPublisher()
   }
  
  private var emptyJust:AnyPublisher<[GitHubUser],Never> = Just([]).eraseToAnyPublisher()
  
  private var text :AnyPublisher<String,Never> {
    
    $searchText
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .removeDuplicates()
      .map {$0}
     .eraseToAnyPublisher()
  }
  
  init() {
    
  
    
    $searchText
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
     .removeDuplicates()
      .flatMap { (searchText) -> AnyPublisher<[GitHubUser],Never> in
        
        guard  searchText.isEmpty == false else {return self.emptyJust}
        
        self.models = []
        
        print("Search Text",searchText)
        let endPoint: Endpoint = .userSearch(searchFilter: searchText, pages: 15)
        return GitHubApi.shared.fetchUsersWithError(from: endPoint)
          .catch { error -> AnyPublisher<[GitHubUser], Never> in
            print("Error Block")
            self.alertDataInfo = AlertDataInfo(title: "Ощибка при поиске пользователей", message: error.localizedDescription)
            return self.emptyJust
        }.eraseToAnyPublisher()
        
    }.subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] in self?.models = $0})
    .store(in: &cancellable)
      

    
    
  }
  // Cancallable
  
  private var cancellable: Set<AnyCancellable> =  []
  
}
