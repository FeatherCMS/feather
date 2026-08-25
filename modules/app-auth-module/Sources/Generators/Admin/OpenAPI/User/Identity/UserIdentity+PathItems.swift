//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 10..
//

import FeatherOpenAPI

struct UserIdentitySessionPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserIdentitySessionListOperation() }
    var delete: OperationRepresentable? { UserIdentitySessionBulkDeleteOperation() }
}

struct UserIdentitySessionIdPathItems: PathItemRepresentable {
}
