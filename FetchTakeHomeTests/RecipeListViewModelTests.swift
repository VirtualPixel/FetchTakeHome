//
//  RecipeListViewModelTests.swift
//  FetchTakeHomeTests
//
//  Created by Justin Wells on 1/30/25.
//

import XCTest
@testable import FetchTakeHome

@MainActor
final class RecipeListViewModelTests: XCTestCase {
    var sut: RecipeListViewModel!
    
    override func setUp() {
        super.setUp()
        sut = RecipeListViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testSuccessfulRecipeDownload() async {
        await sut.downloadRecipes()
        
        XCTAssertFalse(sut.groupedRecipes.isEmpty)
        XCTAssertNil(sut.alertItem)
        
        for (cuisine, recipes) in sut.groupedRecipes {
            XCTAssertFalse(cuisine.isEmpty)
            XCTAssertFalse(recipes.isEmpty)
            
            for recipe in recipes {
                XCTAssertEqual(recipe.cuisine, cuisine)
            }
            
            let sortedNames = recipes.map { $0.name }.sorted()
            XCTAssertEqual(recipes.map { $0.name }, sortedNames)
        }
    }
    
    func testImageLoading() async {
        guard let testRecipe = (try? await APIManager.getRecipeList())?.first,
              let imageUrl = testRecipe.wrappedPhotoUrlSmall else {
            XCTFail("Failed to get test recipe")
            return
        }
        
        let image = await sut.loadImage(from: imageUrl, recipeId: testRecipe.id.uuidString)
        XCTAssertNotNil(image)
    }
}
