import FeatherOpenAPI

struct AuthCredentialPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthCredentialCreateOperation() }
    var delete: OperationRepresentable? { AuthCredentialDeleteOperation() }
}

struct AuthCredentialSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthCredentialSearchOperation() }
}

struct AuthCredentialListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AuthCredentialListOperation() }
}

struct AuthCredentialIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AuthCredentialGetOperation() }
    var put: OperationRepresentable? { AuthCredentialUpdateOperation() }
    var patch: OperationRepresentable? { AuthCredentialPatchOperation() }
}
