import FeatherOpenAPI

struct AuthCredentialPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthCredentialCreateOperation() }
    var delete: (any OperationRepresentable)? {
        AuthCredentialRemoveOperation()
    }
}

struct AuthCredentialSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthCredentialSearchOperation() }
}

struct AuthCredentialListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AuthCredentialListOperation() }
}

struct AuthCredentialIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AuthCredentialGetOperation() }
    var put: (any OperationRepresentable)? { AuthCredentialUpdateOperation() }
    var patch: (any OperationRepresentable)? { AuthCredentialPatchOperation() }
}
