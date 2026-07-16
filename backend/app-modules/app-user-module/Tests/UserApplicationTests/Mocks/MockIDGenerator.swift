//
//  MockIDGenerator.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application

struct FixedIDGenerator: IDGenerator {
    let id: String

    func generate() -> String {
        id
    }
}
