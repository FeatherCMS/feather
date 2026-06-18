//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 23..
//

import FeatherOpenAPI

struct AuthRegisterPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthRegisterOperation() }
}
