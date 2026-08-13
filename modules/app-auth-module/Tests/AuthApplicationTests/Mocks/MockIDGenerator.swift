//
//  MockIDGenerator.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain

struct FixedIDGenerator: IDGenerator {
    let id: String

    func generate() -> String {
        id
    }
}
