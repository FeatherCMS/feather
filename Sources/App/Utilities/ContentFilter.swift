//
//  ContentFilter.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 21..
//

import Foundation
import ViewKit

protocol ContentFilter: FormFieldOptionRepresentable {
    var key: String { get }
    var label: String { get }

    func filter(_ input: String) -> String
}

extension ContentFilter {
    var label: String { self.key }
    func filter(_ input: String) -> String { input }
    
    var formFieldOption: FormFieldOption {
        .init(key: self.key, label: self.label)
    }
}
