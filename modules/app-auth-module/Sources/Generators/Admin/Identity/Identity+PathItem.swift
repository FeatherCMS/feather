import FeatherOpenAPI

struct UserIdentitySessionPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? {
        UserIdentitySessionListOperation()
    }
    var delete: (any OperationRepresentable)? {
        UserIdentitySessionRemoveOperation()
    }
}
