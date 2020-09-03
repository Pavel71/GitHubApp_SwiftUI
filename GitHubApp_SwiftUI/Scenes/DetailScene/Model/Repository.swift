//
//  Repository.swift
//  GitHubExplore
//
//  Created by Pablo Cornejo on 7/18/19.
//  Copyright © 2019 Pablo Cornejo Pierola. All rights reserved.
//

import Foundation


//struct ReposResult : Decodable {
//  var language        : String
//  var repos           : [Repository]
//  
//  enum CodingKeys: String, CodingKey {
//      case repos = "items"
//      case language
//  }
//}



struct Repository : Decodable,Hashable {
  
  
  var name            : String
  var language        : String?
  
  var updatedAt       : String
  var stars           : Int
  
     enum CodingKeys  : String, CodingKey {
          case name
          case language
          case updatedAt
          case stars = "watchers"
          
      }
  
  
}
