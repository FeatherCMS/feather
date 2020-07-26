//
//  OptionListFormField.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import Foundation
import ViewKit

/// can be used for option lists
public struct OptionListFormField: FormField {

    /// values of the selected option keys
    public var values: [String]
    /// error message
    public var error: String?
    /// available options
    public var options: [FormFieldOption]
    
    public init(values: [String] = [], error: String? = nil, options: [FormFieldOption] = []) {
        self.values = values
        self.error = error
        self.options = options
    }
}

