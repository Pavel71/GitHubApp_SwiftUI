//
//  ImageLoaders.swift
//  GitHubApp_SwiftUI
//
//  Created by Павел Мишагин on 21.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import Foundation

//
//  ImageData.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import UIKit
import Combine

 //---------------
class ImageLoaderCache {

    static let shared = ImageLoaderCache()

    var loaders: NSCache<NSString, ImageLoader> = NSCache()

    func loaderFor(path: URL) -> ImageLoader {
        let key = NSString(string: "\(path)")
        if let loader = loaders.object(forKey: key) {
            return loader
        } else {
            
            let loader = ImageLoader(url: path)
            loaders.setObject(loader, forKey: key)
            return loader
        }
    }

}

final class ImageLoader: ObservableObject {
    // input
    @Published var url: URL?
    // output
    @Published var image: UIImage?

    init(url: URL?) {
        self.url = url
        $url
            .flatMap { (path) -> AnyPublisher<UIImage?, Never> in
               self.fetchImage(for: url)
            }
            .assign(to: \.image, on: self)
            .store(in: &self.cancellableSet)
    }
    private var cancellableSet: Set<AnyCancellable> = []

    private func fetchImage(for url: URL?)
                            -> AnyPublisher <UIImage?, Never> {
        guard url != nil, image == nil else {
            return Just(nil).eraseToAnyPublisher()             // 1
        }
        return
            URLSession.shared.dataTaskPublisher(for: url!)     // 2
                .map { UIImage(data: $0.data) }                // 3
                .replaceError(with: nil)                       // 4
                .receive(on: RunLoop.main)                     // 5
                .eraseToAnyPublisher()                         // 6
    }

    deinit {
        for cancell in cancellableSet {
            cancell.cancel()
        }
    }
}
