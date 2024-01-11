//
//  HomeViewModel.swift
//  Tokenizer
//
//  Created by Somebody on 10/01/2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    // MARK: - Inputs
    
    @Published var input: String = ""
    @Published var selectedLanguageIndex = 0
    
    // MARK: - Outputs
    
    @Published private(set) var languages: [Language] = Language.allCases
    @Published private(set) var output: String = ""
    var clearInputPublisher: AnyPublisher<Void, Never> {
        clearInputSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Properties
    
    private let tokenizer: Tokenizable
    private let clearInputSubject = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(tokenizer: Tokenizable) {
        self.tokenizer = tokenizer
        setupBindings()
    }
    
    private func setupBindings() {
        $input
            .dropFirst()
            .sink { [weak self] input in
                guard let self else { return }
                let language = languages[selectedLanguageIndex]
                
                DispatchQueue.global(qos: .userInteractive).async {
                    let sentences = self.tokenizer.tokenize(string: input, language: language)
                    DispatchQueue.main.async {
                        self.output = sentences
                            .map { $0.isEmpty ? $0 : "- \($0)" }
                            .joined(separator: "\n")
                    }
                }
            }
            .store(in: &subscriptions)
        
        $selectedLanguageIndex
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] index in
                guard let self else { return }
                clearInputSubject.send()
            }
            .store(in: &subscriptions)
    }
}
