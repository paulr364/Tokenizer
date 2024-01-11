//
//  Tokenizable.swift
//  Tokenizer
//
//  Created by Somebody on 10/01/2024.
//

import Foundation

protocol Tokenizable {
    func tokenize(string: String, language: Language) -> [String]
}
