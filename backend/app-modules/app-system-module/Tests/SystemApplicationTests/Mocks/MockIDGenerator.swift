//
//  MockIDGenerator.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

import Application
import Domain

struct FixedIDGenerator: IDGenerator {
    let id: String

    func generate() -> String {
        id
    }
}
