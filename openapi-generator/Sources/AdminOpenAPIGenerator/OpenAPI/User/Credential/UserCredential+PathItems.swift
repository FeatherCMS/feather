import FeatherOpenAPI

struct UserCredentialPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserCredentialCreateOperation() }
    var delete: OperationRepresentable? { UserCredentialBulkDeleteOperation() }
}

struct UserCredentialSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserCredentialSearchOperation() }
}

struct UserCredentialFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserCredentialFiltersOperation() }
}

struct UserCredentialIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserCredentialGetOperation() }
    var put: OperationRepresentable? { UserCredentialUpdateOperation() }
    var patch: OperationRepresentable? { UserCredentialPatchOperation() }
    var delete: OperationRepresentable? { UserCredentialDeleteOperation() }
}
