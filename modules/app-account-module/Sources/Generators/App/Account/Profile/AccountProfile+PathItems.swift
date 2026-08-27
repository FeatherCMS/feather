import FeatherOpenAPI

struct AccountProfilePathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AccountProfileGetOperation() }
    var put: OperationRepresentable? { AccountProfileUpdateOperation() }
}
