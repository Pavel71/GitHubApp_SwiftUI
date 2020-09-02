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
  
  
  //MARK: - Input
  @Published var isLastItem    : GitHubUser?
  @Published var searchText    : String = ""
  
  //MARK: - Output
  @Published var models        : [GitHubUser] = []
  @Published var alertDataInfo : AlertDataInfo?
  @Published var isLoading     : Bool = false
  
  private var searchItems : Int = 15
  
  
  
  
  
  
  // MARK: Publishers
  
  
  
  
  // MARK: - Load New Users Publisher
  private var loadNewUsersPublisher : AnyPublisher<[GitHubUser],Never>  {
    
    let endPoint: Endpoint = .userSearch(searchFilter: self.searchText, pages: self.searchItems)
    
    return GitHubApi.shared.fetchUsersWithError(from: endPoint)
      .catch { error -> AnyPublisher<[GitHubUser], Never> in
        print("Error Block")
        self.alertDataInfo = AlertDataInfo(title: "Ощибка при Загрузке доп пользователей", message: error.localizedDescription)
        return self.emptyJust
    }.eraseToAnyPublisher()
  }
  
  // MARK: - Is Last Item Publisher
  private var isLastItemScrolled : AnyPublisher<Bool,Never> {

    $isLastItem
      .map({ (lastUser) -> Bool in
         
        guard
          let lastU = lastUser
        else {return false}
       
        return self.models.isLastItem(lastU)

      })           // 1 - Чек Nil + Чек Ласт Item
      .filter{$0} // 2 - Только если последний
      .eraseToAnyPublisher()
  }
  
  private var emptyJust:AnyPublisher<[GitHubUser],Never> = Just([]).eraseToAnyPublisher()
  
  private var text : AnyPublisher<String,Never> {
    
    $searchText
      .debounce(for: 0.3, scheduler: RunLoop.main)
      .removeDuplicates()
     .eraseToAnyPublisher()
  }
  
  init() {
    
  
    // MARK: Search Text  Input
    text

      .flatMap { (searchText) -> AnyPublisher<[GitHubUser],Never> in
        
        guard
          searchText.isEmpty == false,
          self.isLoading     == false
        else {return self.emptyJust}
        
        self.isLoading   = true
        self.models      = []
        self.searchItems = 15
        
        print("Search Text",searchText)
        return self.loadNewUsersPublisher
        
    }.subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] in
        self?.isLoading = false
        self?.models = $0})
    .store(in: &cancellable)
    
    
    // MARK: Is Last Item Input
    isLastItemScrolled
      .flatMap { (_) -> AnyPublisher<[GitHubUser],Never> in
        
        withAnimation {
           self.isLoading    = true
        }
       
        self.searchItems += 15
        return self.loadNewUsersPublisher
        
    }
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] (_models) in
        
        withAnimation {
          self?.isLoading    = false
        }
   
        let filterArray = _models.filter{self?.models.contains($0) == false} 
        
        self?.models.append(contentsOf: filterArray)
        
      })
    .store(in: &cancellable)
      
    
    
    

    
    
  }
  // Cancallable
  
  private var cancellable: Set<AnyCancellable> =  []
  
}
