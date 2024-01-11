//
//  HomeViewModelTests.swift
//  TokenizerTests
//
//  Created by Somebody on 11/01/2024.
//

import XCTest
import Combine
@testable import Tokenizer

final class HomeViewModelTests: XCTestCase {
    
    private var tokenizer: TokenizerMock!
    private var sut: HomeViewModel!
    private var subscriptions: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        tokenizer = TokenizerMock()
        sut = HomeViewModel(tokenizer: tokenizer)
        subscriptions = []
    }
    
    func testLanguages() {
        XCTAssertEqual(sut.languages, [
            .english, .spanish
        ])
    }
    
    func testInputsPropagated() {
        let givenString = """
        Hi my name is Oxus and I am here to start the project and learn if it is possible
        """
        XCTAssertNil(tokenizer.string)
        XCTAssertNil(tokenizer.language)
        
        let expectation = self.expectation(description: "Output received")
        sut.$output
            .dropFirst()
            .sink { [unowned self] output in
                XCTAssertEqual(tokenizer.string, givenString)
                XCTAssertEqual(tokenizer.language, .english)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        sut.input = givenString
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testOutput() {
        tokenizer.sentences = [
            "Hi my name is Oxus ",
            "And I am here to start the project ",
            "And learn ",
            "If it is possible"
        ]
        
        let expectation = self.expectation(description: "Output received")
        sut.$output
            .dropFirst()
            .sink { output in
                XCTAssertEqual(output, "- Hi my name is Oxus \n- And I am here to start the project \n- And learn \n- If it is possible")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        sut.input = "some input"
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testClearInputs_OnLanguageSelection() {
        let expectation = self.expectation(description: "Inputs cleared")
        
        sut.clearInputPublisher
            .sink(receiveValue: expectation.fulfill)
            .store(in: &subscriptions)
        ty
        sut.selectedLanguageIndex = 1
        wait(for: [expectation], timeout: 1)
    }
}
