import FeatherOpenAPI

struct AuthCredentialPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AuthCredentialListOperation() }
    var post: (any OperationRepresentable)? { AuthCredentialCreateOperation() }
    var delete: (any OperationRepresentable)? {
        AuthCredentialRemoveOperation()
    }
}

struct AuthCredentialQueryPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthCredentialQueryOperation() }
}

struct AuthCredentialIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AuthCredentialGetOperation() }
    var put: (any OperationRepresentable)? { AuthCredentialUpdateOperation() }
    var patch: (any OperationRepresentable)? { AuthCredentialPatchOperation() }
}
