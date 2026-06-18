//
//  File.swift
//  app-metadata-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import Domain
import Application

struct FixedIDGenerator: IDGenerator {
    let id: String

    func generate() -> String {
        id
    }
}
