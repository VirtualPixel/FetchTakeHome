//
//  APIManager.swift
//  FetchTakeHome
//
//  Created by Justin Wells on 1/30/25.
//

import Foundation

enum APIEndpoint: String {
    
    case recipeUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    case malformedUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    case emptyUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    #if DEBUG
    case invalidTestUrl = "\\invalid\\url"  
    #endif
    
    var url: URL? {
        URL(string: self.rawValue)
    }
}

enum APIError: Error {
    
    case invalidURL, networkError, decodingError, serverError, unexpectedError
    
    var userFriendlyDescription: String {
        switch self {
        case .serverError:
            "Server error. Please try again later."
        case .decodingError:
            "There was an issue processing the data. Please try again."
        case .invalidURL:
            "Invalid URL. Please contact support."
        case .networkError:
            "There was an issue connecting to the server! Please check your internet connection and try again."
        case .unexpectedError:
            "An unexpted error occurred. Please try again."
        }
    }
    
    static func from(_ error: Error) -> APIError {
        switch error {
        case is URLError:
            return .networkError
        case is DecodingError:
            return .decodingError
        case let apiError as APIError:
            return apiError
        default:
            return .unexpectedError
        }
    }
}

class APIManager {
    static func getRecipeList(recipeUrl: APIEndpoint = .recipeUrl) async throws -> [Recipe] {
        guard let url = recipeUrl.url else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.serverError
            }
            
            let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return decodedResponse.recipes
        } catch {
            throw APIError.from(error)
        }
    }
}
