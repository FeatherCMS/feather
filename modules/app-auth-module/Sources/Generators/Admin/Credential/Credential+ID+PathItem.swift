import FeatherOpenAPI

struct AuthCredentialIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AuthCredentialGetOperation() }
    var put: (any OperationRepresentable)? { AuthCredentialUpdateOperation() }
    var patch: (any OperationRepresentable)? { AuthCredentialPatchOperation() }
}
