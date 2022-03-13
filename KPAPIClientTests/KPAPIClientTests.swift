//
//  KPAPIClientTests.swift
//  KPAPIClientTests
//
//  Created by Chan, Paul | Paul on 2022/03/12.
//

import XCTest
@testable import KPAPIClient

class KPAPIClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testKanaKanjiViewModel() throws {
        let expectation = self.expectation(description: "KanaKanji viewModel call API Complete Expectation")

        let viewModel = KanaKanjiViewModel()
        viewModel.textToAPI = "きょうはよいてんきです。"
        viewModel.KanaKanjiOptionSelectedArray = [true, true, true, true, true]
        viewModel.KanaKanjiDictionarySelectedArray = [true, true, true, true, true]

        viewModel.KanaKanjiFormatSelection = KanaKanjiFormat.allCases.firstIndex(of: .hiragana) ?? 0
        viewModel.KanaKanjiModeSelection = KanaKanjiMode.allCases.firstIndex(of: .kanakanji) ?? 0
        
        viewModel.fetch { result in
            switch result {
            case .finished:
                XCTAssertNotNil(viewModel.response)
                XCTAssertNil(viewModel.error)
                XCTAssert(viewModel.status == .APISuccess)
            case .failure(let error):
                // normally will success in this case
                switch error {
                case .invalidURL:
                    XCTFail("KanaKanji API fail with invalidURL")
                case .decodeFailure:
                    XCTFail("KanaKanji API fail with decodeFailure")
                case .serverError:
                    XCTFail("KanaKanji API fail with serverError")
                case .customError(desc: let desc):
                    XCTFail("KanaKanji API fail with error: \(desc)")
                }
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10.0) { error in
            if error != nil {
                XCTFail("KanaKanji API call Expectation Time out")
            }
        }
    }
    
    func testRubiFuriViewModel() throws {
        let expectation = self.expectation(description: "Ruby Furi viewModel call API Complete Expectation")

        let viewModel = RubyFuriViewModel()
        viewModel.textToAPI = "漢字かな交じり文にふりがなを振ること。"
        viewModel.gradeSelection = 1
                
        viewModel.fetch { result in
            switch result {
            case .finished:
                XCTAssertNotNil(viewModel.response)
                XCTAssertNil(viewModel.error)
                XCTAssert(viewModel.status == .APISuccess)
            case .failure(let error):
                // normally will success in this case
                switch error {
                case .invalidURL:
                    XCTFail("RubyFuri API fail with invalidURL")
                case .decodeFailure:
                    XCTFail("RubyFuri API fail with decodeFailure")
                case .serverError:
                    XCTFail("RubyFuri API fail with serverError")
                case .customError(desc: let desc):
                    XCTFail("RubyFuri API fail with error: \(desc)")
                }
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10.0) { error in
            if error != nil {
                XCTFail("RubyFuri API call Expectation Time out")
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
