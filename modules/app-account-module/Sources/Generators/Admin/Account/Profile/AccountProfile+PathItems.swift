import FeatherOpenAPI

struct AdminAccountProfilePathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AdminAccountProfileGetOperation() }
    var put: OperationRepresentable? { AdminAccountProfileUpdateOperation() }
}
