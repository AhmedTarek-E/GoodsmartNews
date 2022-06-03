//
//  GetNewsUseCaseTests.swift
//  GoodsmartNewsTests
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import XCTest
@testable import GoodsmartNews

class GetNewsUseCaseTests: XCTestCase {
    
    var sut: GetNewsUseCase!
    var newsRepo: MockNewsRepository!

    override func setUpWithError() throws {
        newsRepo = MockNewsRepository()
        sut = GetNewsUseCaseImp(repository: newsRepo)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGivenThatRepositoryReturnsDataWhenUseCaseIsCalledThenItShouldReturnData() {
        let expectation = XCTestExpectation(description: "fetching articles")
        
        let observable = sut.execute()
        _ = observable.subscribe { articles in
            XCTAssertFalse(articles.isEmpty, "articles should not be empty")
            expectation.fulfill()
        } onError: { error in
            XCTAssert(false, "Throws an error")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testGivenThatRepoThrowsWhenUseCaseIsCalledThenItShouldProbagateTheError() {
        let expectation = XCTestExpectation(description: "fetching articles")
        newsRepo.shouldThrow = true
        
        let observable = sut.execute()
        _ = observable.subscribe { articles in
            XCTAssert(false, "It should not return data")
            expectation.fulfill()
        } onError: { error in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }

}
