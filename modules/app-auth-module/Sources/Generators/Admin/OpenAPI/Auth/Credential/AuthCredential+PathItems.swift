import FeatherOpenAPI

struct AuthCredentialPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthCredentialCreateOperation() }
    var delete: OperationRepresentable? { AuthCredentialBulkDeleteOperation() }
}

struct AuthCredentialSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthCredentialSearchOperation() }
}

struct AuthCredentialFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AuthCredentialFiltersOperation() }
}

struct AuthCredentialIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AuthCredentialGetOperation() }
    var put: OperationRepresentable? { AuthCredentialUpdateOperation() }
    var patch: OperationRepresentable? { AuthCredentialPatchOperation() }
    var delete: OperationRepresentable? { AuthCredentialDeleteOperation() }
}
