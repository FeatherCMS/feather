import FeatherOpenAPI

struct AuthCredentialQueryPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthCredentialQueryOperation() }
}
