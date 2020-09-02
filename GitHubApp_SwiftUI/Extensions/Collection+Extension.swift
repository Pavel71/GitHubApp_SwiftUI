//
//  Collection+Extensions.swift
//  GitHubApp_SwiftUI
//
//  Created by Павел Мишагин on 02.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import SwiftUI

extension RandomAccessCollection where Self.Element: Identifiable {
    
    public func isLastItem<Item: Identifiable>(_ item: Item) -> Bool {
        guard isEmpty == false else {
            return false
        }
        
        guard let itemIndex = lastIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) }) else {
            return false
        }
        
        let distance = self.distance(from: itemIndex, to: endIndex)
        return distance == 1
    }
    
}
