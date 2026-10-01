//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 10..
//

import FeatherOpenAPI

struct UserIdentitySessionPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { UserIdentitySessionListOperation() }
    var delete: (any OperationRepresentable)? {
        UserIdentitySessionRemoveOperation()
    }
}

struct UserIdentitySessionIdPathItems: PathItemRepresentable {
}
