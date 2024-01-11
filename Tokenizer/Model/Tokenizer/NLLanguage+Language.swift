//
//  NLLanguage+Language.swift
//  Tokenizer
//
//  Created by Somebody on 10/01/2024.
//

import NaturalLanguage

extension NLLanguage {
    init(language: Language) {
        switch language {
        case .english:
            self = .english
        case .spanish:
            self = .spanish
        }
    }
}
