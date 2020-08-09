//
//  Environmetn+FetchValue.swift
//  
//
//  Created by Michael Critz on 8/9/20.
//

import Vapor

extension Environment {
    static func fetch(_ key: String) -> String {
        let fetchedValue: String? = Environment.get(key)
        guard let realValue = fetchedValue else {
            precondition(false, """
                \(key) is not defined in the Environment.
                Check README.md or documentation for how to set environment variables.
                """)
        }
        return realValue
    }
}
