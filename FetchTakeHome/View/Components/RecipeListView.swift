//
//  RecipeListView.swift
//  FetchTakeHome
//
//  Created by Justin Wells on 1/30/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        List {
            if viewModel.groupedRecipes.isEmpty {
                noRecipesView()
            } else {
                ForEach(Array(viewModel.groupedRecipes.keys.sorted()), id: \.self) { cuisine in
                    Section(cuisine) {
                        ForEach(viewModel.groupedRecipes[cuisine] ?? []) { recipe in
                            recipeView(recipe: recipe)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .task(viewModel.downloadRecipes)
        .refreshable(action: viewModel.downloadRecipes)
        .accessibilityAction(named: "Refresh Recipes") {
            Task {
                await viewModel.downloadRecipes()
            }
        }
        .alert(item: $viewModel.alertItem) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: alert.dismissButton
            )
        }
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // Recipe list item
    private func recipeView(recipe: Recipe) -> some View {
        
        HStack(spacing: 16) {
            ImageLoaderView(
                url: recipe.wrappedPhotoUrlSmall,
                recipeId: recipe.id.uuidString,
                viewModel: viewModel
            )
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .lineLimit(2)
                    .accessibilityAddTraits(.isHeader)
                
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(recipe.name), \(recipe.cuisine) cuisine")
                
                if recipe.sourceUrl != nil || recipe.youtubeUrl != nil {
                    HStack(spacing: 20) {
                        Group {
                            if let sourceUrl = recipe.wrappedSourceUrl {
                                Button {
                                    UIApplication.shared.open(sourceUrl)
                                } label: {
                                    Image(systemName: "link")
                                        .foregroundStyle(.blue)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Recipe Source")
                                .accessibilityHint("Visit recipe source for \(recipe.name)")
                            }
                            if let youtubeUrl = recipe.wrappedYouTubeUrl {
                                Button {
                                    UIApplication.shared.open(youtubeUrl)
                                } label: {
                                    Image(systemName: "play.rectangle.fill")
                                        .foregroundStyle(.red)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Youtube link")
                                .accessibilityHint("Watch recipe video for \(recipe.name) on Youtube")
                            }
                        }
                    }
                    .font(.footnote)
                }
            }
            .padding(.vertical, 8)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("\(recipe.name) Recipe")
            .accessibilityHint(
                "Recipe from \(recipe.cuisine) cuisine. \(recipe.sourceUrl != nil ? "Has recipe link. " : "")\(recipe.youtubeUrl != nil ? "Has video tutorial." : "")"
            )
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.footnote)
        }
        .padding(.horizontal, 8)
        .contentShape(Rectangle())
    }
    
    private func noRecipesView() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            
            VStack(spacing: 8) {
                Text("No Recipes Available")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Pull down to refresh")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("No recipes available")
            .accessibilityHint("Pull down to refresh the recipe list")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    struct ImageLoaderView: View {
        let url: URL?
        let recipeId: String
        let viewModel: RecipeListViewModel
        @State private var image: UIImage?
        @State private var isLoading = false
        
        var body: some View {
            Group {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .accessibilityLabel("Loading recipe image")
                } else if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .accessibilityLabel("Recipe photo")
                } else {
                    Image(systemName: "fork.knife")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("No recipe photo available")
                }
            }
            .frame(width: 50, height: 50)
            .task(id: recipeId) {
                image = nil
                isLoading = true
                defer { isLoading = false }
                
                guard let url = url else { return }
                
                image = await viewModel.loadImage(from: url, recipeId: recipeId)
            }
        }
    }
}

#Preview {
    NavigationStack {
        RecipeListView()
    }
}
