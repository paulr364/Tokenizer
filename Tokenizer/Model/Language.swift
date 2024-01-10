//
//  Language.swift
//  Tokenizer
//
//  Created by Somebody on 10/01/2024.
//

import Foundation

enum Language: CaseIterable {
    case english
    case spanish
    
    var title: String {
        switch self {
        case .english:
            return "English"
        case .spanish:
            return "Spanish"
        }
    }
}
