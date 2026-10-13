//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 10..
//

import FeatherOpenAPI

struct UserIdentityPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { UserIdentityCreateOperation() }
    //    var get: (any OperationRepresentable)? { UserIdentityListOperation() }
    var delete: (any OperationRepresentable)? { UserIdentityRemoveOperation() }
}

struct UserIdentitySearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { UserIdentitySearchOperation() }
}

struct UserIdentityListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { UserIdentityListOperation() }
}

struct UserIdentityIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { UserIdentityGetOperation() }
    var put: (any OperationRepresentable)? { UserIdentityUpdateOperation() }
    var patch: (any OperationRepresentable)? { UserIdentityPatchOperation() }
}
