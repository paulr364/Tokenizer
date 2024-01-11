//
//  TokenizerTests.swift
//  TokenizerTests
//
//  Created by Somebody on 10/01/2024.
//

import XCTest
@testable import Tokenizer

final class TokenizerTests: XCTestCase {
    
    private var sut: Tokenizer!

    override func setUpWithError() throws {
        sut = Tokenizer()
    }
    
    // MARK: - English
    
    func testTokenize_NoKeywords_InEnglish() {
        let givenString = "I am here to start the project"
        let sentences = sut.tokenize(string: givenString, language: .english)
        
        XCTAssertEqual(sentences, [
            givenString
        ])
    }
    
    func testTokenize_WithPunctuation_InEnglish() {
        let givenString = "What are we doing here?"
        let sentences = sut.tokenize(string: givenString, language: .english)
        
        XCTAssertEqual(sentences, [
            "What are we doing here"
        ])
    }
    
    func testTokenize_WithWhitespace_InEnglish() {
        let givenString = "What are we doing here  "
        let sentences = sut.tokenize(string: givenString, language: .english)
        
        XCTAssertEqual(sentences, [
            "What are we doing here"
        ])
    }
    
    func testTokenize_InEnglish() {
        let givenString = """
        Hi my name is Oxus and I am here to start the project and learn if it is possible
        """
        let sentences = sut.tokenize(string: givenString, language: .english)
        
        XCTAssertEqual(sentences, [
            "Hi my name is Oxus ",
            "And I am here to start the project ",
            "And learn ",
            "If it is possible"
        ])
    }
    
    // MARK: - Spanish
    
    func testTokenize_NoKeywords_InSpanish() {
        let givenString = "El sol brilla en el cielo azul, iluminando el día con su resplandor"
        let sentences = sut.tokenize(string: givenString, language: .spanish)
        
        XCTAssertEqual(sentences, [
            givenString
        ])
    }
    
    func testTokenize_Question_InSpanish() {
        let givenString = """
        ¿Tiene este precioso Caddy, y no te quiere pagar lo que te debe?
        """
        let sentences = sut.tokenize(string: givenString, language: .spanish)
        
        XCTAssertEqual(sentences, [
            "Tiene este precioso Caddy, ",
            "Y no te quiere pagar lo que te debe"
        ])
    }
    
    func testTokenize_InSpanish() {
        let givenString = """
        Por supuesto, aquí tienes una oración más larga en español: "Mientras caminaba por el pintoresco sendero, el sol radiante del mediodía brillaba en lo alto, pintando el cielo de un azul profundo y resaltando los colores vibrantes de las flores que bordeaban el camino, creando un escenario que inspiraba asombro y alegría en cada paso.
        """
        let sentences = sut.tokenize(string: givenString, language: .spanish)
        
        XCTAssertEqual(sentences, [
            "Por supuesto, aquí tienes una oración más larga en español: \"Mientras caminaba por el pintoresco sendero, el sol radiante del mediodía brillaba en lo alto, pintando el cielo de un azul profundo ",
            "Y resaltando los colores vibrantes de las flores que bordeaban el camino, creando un escenario que inspiraba asombro ",
            "Y alegría en cada paso"
        ])
    }
}
