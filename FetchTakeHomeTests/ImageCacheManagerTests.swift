//
//  ImageCacheManagerTests.swift
//  FetchTakeHomeTests
//
//  Created by Justin Wells on 1/30/25.
//

import XCTest
@testable import FetchTakeHome

final class ImageCacheManagerTests: XCTestCase {
    var sut: ImageCacheManager!
    let testImage = UIImage(systemName: "star.fill")!
    let testUrl = URL(string: "https://test.com/image.jpg")!
    let testRecipeId = "test-recipe-123"
    
    override func setUp() async throws {
        try await super.setUp()
        sut = try ImageCacheManager()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        // Clean up test files
        let fileManager = FileManager.default
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("RecipeImages")
        try? fileManager.removeItem(at: cacheDir)
        sut = nil
    }
    
    func testSaveAndRetrieveImage() async throws {
        // Save image
        try await sut.saveImage(testImage, for: testUrl, recipeId: testRecipeId)
        
        // Retrieve image
        let retrievedImage = try await sut.getImage(for: testUrl, recipeId: testRecipeId)
        XCTAssertNotNil(retrievedImage)
    }
    
    func testNonexistentImage() async throws {
        let nonexistentImage = try await sut.getImage(
            for: URL(string: "https://nonexistent.com/image.jpg")!,
            recipeId: "nonexistent-123"
        )
        XCTAssertNil(nonexistentImage)
    }
}
