//
//  RemoteFlickerFeedLoader.swift
//  FlickerImages
//
//  Created by Julio Rico on 21/10/22.
//

import Foundation

public final class RemoteFlickerFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity, invalidData
    }
    
    public typealias Result = FeedLoader.Result
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteFlickerFeedLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FlickerImageMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteFlickImage {
    func toModels() -> [FlickerImage] {
        map { FlickerImage(id: $0.id, owner: $0.owner, secret: $0.secret, server: $0.server, farm: $0.farm, title: $0.title) }
    }
}

