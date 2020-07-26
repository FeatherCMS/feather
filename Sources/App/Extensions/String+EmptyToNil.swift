//
//  String+EmptyToNil.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 02. 21..
//

import Foundation

extension String {
    var emptyToNil: String? {
        self.isEmpty ? nil : self
    }
}
