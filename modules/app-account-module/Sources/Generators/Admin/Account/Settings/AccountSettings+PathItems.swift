import FeatherOpenAPI

struct AccountSettingsPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AccountSettingsGetOperation() }
    var put: (any OperationRepresentable)? { AccountSettingsUpdateOperation() }
}
