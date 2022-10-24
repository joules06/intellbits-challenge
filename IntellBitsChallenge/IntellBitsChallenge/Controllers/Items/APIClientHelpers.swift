//
//  APIClientHelpers.swift
//  IntellBitsChallenge
//
//  Created by Julio Rico on 24/10/22.
//

import Foundation
class APIClientHelper {
    func createURL(from baseURL: String, keyword: String, itemsPerPage: Int, currentPage: Int, apiKey: String) -> URL {
        let params = [
            "method" : "flickr.photos.search",
            "api_key" : "1ba0e65518d2a67bcafaad462db151cb",
            "text" : keyword,
            "per_page" : String(itemsPerPage),
            "format" : "json",
            "nojsoncallback": "1",
            "page": String(currentPage)
        ]
        
        var url = URLComponents(string: baseURL)!
        url.queryItems = .init(params)
        
        return url.url!
    }
    
    func checkForPaging(maxPageSize: Int?, currentPage: Int) -> Bool {
        if let maxPageSize = maxPageSize, currentPage < maxPageSize {
            return true
        }
        
        return false
    }
    
    func isLastElement(index: Int, arrayElements: Int) -> Bool {
        arrayElements - 1 == index
    }
    
    func canGetMoreImages(for indexCell: Int, elementsInArray: Int, maxPageSize: Int?, currentPage: Int, isLoading: Bool) -> Bool {
        isLastElement(index: indexCell, arrayElements: elementsInArray) && checkForPaging(maxPageSize: maxPageSize, currentPage: currentPage) && !isLoading
    }
}
