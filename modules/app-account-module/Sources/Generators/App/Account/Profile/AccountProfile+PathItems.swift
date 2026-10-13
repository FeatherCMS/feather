import FeatherOpenAPI

struct AccountProfilePathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AccountProfileGetOperation() }
    var put: (any OperationRepresentable)? { AccountProfileUpdateOperation() }
}
