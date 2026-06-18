//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 19..
//

import Application
import NanoID

struct NanoIDGenerator: IDGenerator {
    func generate() -> String {
        NanoID().rawValue
    }
}
