//
//  APIManagerTests.swift
//  FetchTakeHomeTests
//
//  Created by Justin Wells on 1/30/25.
//

import XCTest
@testable import FetchTakeHome

final class APIManagerTests: XCTestCase {
    func testSuccessfulRecipeFetch() async throws {
        let recipes = try await APIManager.getRecipeList(recipeUrl: .recipeUrl)
        XCTAssertFalse(recipes.isEmpty)
        
        let firstRecipe = recipes[0]
        XCTAssertNotNil(firstRecipe.id)
        XCTAssertFalse(firstRecipe.name.isEmpty)
        XCTAssertFalse(firstRecipe.cuisine.isEmpty)
    }
    
    func testMalformedDataHandling() async {
        do {
            _ = try await APIManager.getRecipeList(recipeUrl: .malformedUrl)
            XCTFail("Expected decode error")
        } catch {
            XCTAssertTrue(error is APIError)
            if let apiError = error as? APIError {
                XCTAssertEqual(apiError, .decodingError)
            }
        }
    }
    
    func testEmptyResponse() async throws {
        let recipes = try await APIManager.getRecipeList(recipeUrl: .emptyUrl)
        XCTAssertTrue(recipes.isEmpty)
    }
    
    func testInvalidURL() async {
        do {
            _ = try await APIManager.getRecipeList(recipeUrl: .invalidTestUrl)
            XCTFail("Expected invalid URL error")
        } catch {
            XCTAssertTrue(error is APIError)
            if let apiError = error as? APIError {
                XCTAssertEqual(apiError, .networkError)
            }
        }
    }
}
