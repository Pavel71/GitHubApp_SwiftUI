//
//  AlertDataInfo.swift
//  GitHubApp_SwiftUI
//
//  Created by Павел Мишагин on 01.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import Foundation


struct AlertDataInfo: Identifiable {
    var id = UUID() // Conform to Identifiable
    let title: String
    let message: String
}
