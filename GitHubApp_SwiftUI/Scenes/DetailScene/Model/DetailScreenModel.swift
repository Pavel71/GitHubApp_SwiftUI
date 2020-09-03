//
//  DetailScreenModel.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 25.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import Foundation


struct DetailScreenModel {
  var details : DetailModel
  var repos   : [Repository]?
}


struct DetailModel: Decodable {
  
  var login       : String
  
  var avatarUrl   : URL?
  
  var name        : String?
  
  var createdAt   : String
  
  var location    : String?
  
//  var reposUrl    : [Repository]?
  

}
