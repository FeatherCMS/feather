//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 13..
//

import FeatherOpenAPI
import OpenAPIKit30

public struct CustomResponse: ResponseRepresentable {

    public let description: String
    public var contentMap: ContentMap { [:] }

    public init(description: String) {
        self.description = description
    }

    // MARK: - standard

    static var unauthorized: Self {
        .init(description: "Unauthorized")
    }

    static var forbidden: Self {
        .init(description: "Forbidden")
    }
}
