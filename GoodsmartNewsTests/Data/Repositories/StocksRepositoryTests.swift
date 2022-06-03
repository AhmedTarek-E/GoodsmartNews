//
//  StocksRepositoryTests.swift
//  GoodsmartNewsTests
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import XCTest
@testable import GoodsmartNews

class StocksRepositoryTests: XCTestCase {
    
    var sut: StocksRepositoryImp!
    var dataSource: MockStockDataSource!

    override func setUpWithError() throws {
        dataSource = MockStockDataSource()
        sut = StocksRepositoryImp(dataSource: dataSource)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGivenThatSourceReturnsStockWithManyValuesWhenGetStocksIsCalledThenItShouldReturnListOfStockWithOnlyOnePrice() {
        let expectation = XCTestExpectation(description: "It should return array of tickers")
        
        _ = sut.getStockTickers().subscribe(onNext: { tickers in
            XCTAssertFalse(tickers.isEmpty, "It should return tickers")
            expectation.fulfill()
            
        }, onError: { error in
            XCTAssert(false, "It should not fail")
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 2)
    }

}
