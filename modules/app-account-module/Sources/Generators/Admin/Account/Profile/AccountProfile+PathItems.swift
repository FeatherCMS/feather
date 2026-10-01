import FeatherOpenAPI

struct AdminAccountProfilePathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AdminAccountProfileGetOperation() }
    var put: (any OperationRepresentable)? { AdminAccountProfileUpdateOperation() }
}
