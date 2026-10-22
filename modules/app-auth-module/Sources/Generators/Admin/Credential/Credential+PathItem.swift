import FeatherOpenAPI

struct AuthCredentialPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AuthCredentialListOperation() }
    var post: (any OperationRepresentable)? { AuthCredentialCreateOperation() }
    var delete: (any OperationRepresentable)? { AuthCredentialRemoveOperation() }
}
