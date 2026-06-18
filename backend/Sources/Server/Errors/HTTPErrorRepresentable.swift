//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 19..
//

import SystemDomain
import NIOHTTP1
import HTTPTypes
import OpenAPIRuntime

/*
 NOTE: future improvement:
    - error represetnable could contain an encoder
    - HTTP, plain text, JSON represetnable protocols with defaults
 */
protocol HTTPErrorRepresentable: Error {
    associatedtype Content: Encodable

    var status: HTTPResponseStatus { get }
    var headers: HTTPHeaders? { get }
    var content: Content? { get }
}

extension HTTPErrorRepresentable {
    var headers: HTTPHeaders? { nil }
}

extension Variable.Error: HTTPErrorRepresentable {
    var status: HTTPResponseStatus { .badRequest }

    var headers: HTTPHeaders? {
        [
            "x-foo-bar": "baz"
        ]
    }

    var content: ServerError.Details? {
        .init(
            code: .badRequest,
            message: "\(self)",
            reason: "\(self)"
        )
    }
}
