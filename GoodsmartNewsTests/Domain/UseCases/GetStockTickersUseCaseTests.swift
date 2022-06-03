//
//  GetStockTickersUseCaseTests.swift
//  GoodsmartNewsTests
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import XCTest
@testable import GoodsmartNews

class GetStockTickersUseCaseTests: XCTestCase {
    
    var sut: GetStockTickersUseCase!
    
    var stocksRepo: MockStocksRepository!

    override func setUpWithError() throws {
        stocksRepo = MockStocksRepository()
        sut = GetStockTickersUseCaseImp(repository: stocksRepo)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGivenThatRepositoryReturnsDataWhenUseCaseIsCalledThenItShouldReturnData() {
        let expectation = XCTestExpectation(description: "fetching stocks")
        
        let observable = sut.execute()
        _ = observable.subscribe { stockTickers in
            XCTAssertFalse(stockTickers.isEmpty, "stock tickers should not be empty")
            expectation.fulfill()
        } onError: { error in
            XCTAssert(false, "Throws an error")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testGivenThatRepoThrowsWhenUseCaseIsCalledThenItShouldProbagateTheError() {
        let expectation = XCTestExpectation(description: "fetching stocks")
        stocksRepo.shouldThrow = true
        
        let observable = sut.execute()
        _ = observable.subscribe { stockTickers in
            XCTAssert(false, "It should not return data")
            expectation.fulfill()
        } onError: { error in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }

}
