//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 10..
//

import FeatherOpenAPI

struct UserAccountPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserAccountCreateOperation() }
    //    var get: OperationRepresentable? { UserAccountListOperation() }
    var delete: OperationRepresentable? { UserAccountBulkDeleteOperation() }
}

struct UserAccountSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserAccountSearchOperation() }
}

struct UserAccountFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserAccountFiltersOperation() }
}

struct UserAccountIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserAccountGetOperation() }
    var put: OperationRepresentable? { UserAccountUpdateOperation() }
    var patch: OperationRepresentable? { UserAccountPatchOperation() }
    var delete: OperationRepresentable? { UserAccountDeleteOperation() }
}

struct UserAccountSessionPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserAccountSessionListOperation() }
}

struct UserAccountSessionIdPathItems: PathItemRepresentable {
    var delete: OperationRepresentable? { UserAccountSessionDeleteOperation() }
}
