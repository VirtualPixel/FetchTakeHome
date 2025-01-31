//
//  Recipe.swift
//  FetchTakeHome
//
//  Created by Justin Wells on 1/30/25.
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    let cuisine: String
    let name: String
    let photoUrlSmall: String?
    let photoUrlLarge: String?
    let sourceUrl: String?
    let youtubeUrl: String?
    
    var wrappedPhotoUrlSmall: URL? {
        let url = photoUrlSmall ?? ""
        return URL(string: url) ?? nil
    }
    var wrappedPhotoUrlLarge: URL? {
        let url = photoUrlLarge ?? ""
        return URL(string: url) ?? nil
    }
    var wrappedSourceUrl: URL? {
        let url = sourceUrl ?? ""
        return URL(string: url) ?? nil
    }
    var wrappedYouTubeUrl: URL? {
        let url = youtubeUrl ?? ""
        return URL(string: url) ?? nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid",
             photoUrlSmall = "photo_url_small",
             photoUrlLarge = "photo_url_large",
             sourceUrl = "source_url",
             youtubeUrl = "youtube_url",
             cuisine,
             name
    }
}

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}
