//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 19..
//

import FeatherOpenAPI

public struct Location: LocationRepresentable {
    public var location: String

    public init(_ location: String) {
        self.location = location
    }
}
