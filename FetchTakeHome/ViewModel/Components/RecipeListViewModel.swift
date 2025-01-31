//
//  RecipeListViewModel.swift
//  FetchTakeHome
//
//  Created by Justin Wells on 1/30/25.
//

import SwiftUI

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var groupedRecipes: [String: [Recipe]] = [:]
    @Published var alertItem: AlertItem?
    private let refreshDelay: UInt64 = 250_000_000 // 0.25 Seconds
    private var imageCache: ImageCacheManager?
    
    init() {
        do {
            imageCache = try ImageCacheManager()
        } catch {
            showAlert(title: "Error", message: "Failed to initialize image cache.")
        }
    }
    
    func loadImage(from url: URL, recipeId: String) async -> UIImage {
        do {
            if let cached = try await imageCache?.getImage(for: url, recipeId: recipeId) {
                return cached
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else {
                throw URLError(.cannotDecodeRawData)
            }
            try await imageCache?.saveImage(image, for: url, recipeId: recipeId)
            return image
        } catch {
            // Fixes an issue where scrolling too fast prior to image caching throws
            if !(error is CancellationError) {
                showAlert(title: "Error", message: "Some images failed to load.")
            }
            return UIImage(systemName: "fork.knife")!
        }
    }
    
    @Sendable func downloadRecipes() async {
        do {
            try? await Task.sleep(nanoseconds: refreshDelay)
            let recipes = try await APIManager.getRecipeList()
            groupedRecipes = Dictionary(grouping: recipes) { $0.cuisine }
                .sorted(by: { $0.key < $1.key })
                .reduce(into: [:]) { dict, tuple in
                    dict[tuple.key] = tuple.value.sorted(by: { $0.name < $1.name })
                }
        } catch let error as APIError {
            groupedRecipes = [:]
            showAlert(title: "Error", message: error.userFriendlyDescription)
        } catch {
            groupedRecipes = [:]
            showAlert(title: "Error", message: "An unexpected error has occurred. Please try again later.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertItem = AlertItem(
            title: title,
            message: message,
            dismissButton: .default(Text("OK"))
        )
    }
}
