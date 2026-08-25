//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 10..
//

import FeatherOpenAPI

struct UserIdentityPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserIdentityCreateOperation() }
    //    var get: OperationRepresentable? { UserIdentityListOperation() }
    var delete: OperationRepresentable? { UserIdentityBulkDeleteOperation() }
}

struct UserIdentitySearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserIdentitySearchOperation() }
}

struct UserIdentityFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserIdentityFiltersOperation() }
}

struct UserIdentityIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserIdentityGetOperation() }
    var put: OperationRepresentable? { UserIdentityUpdateOperation() }
    var patch: OperationRepresentable? { UserIdentityPatchOperation() }
}
