//
//  MockIDGenerator.swift
//  app-redirect-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

import FeatherApplication
import FeatherModuleKit
import FeatherDomain

struct FixedIDGenerator: IDGenerator {
    let id: String

    func generate() -> String {
        id
    }
}
