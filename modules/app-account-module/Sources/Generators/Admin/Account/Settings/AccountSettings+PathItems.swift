import FeatherOpenAPI

struct AccountSettingsPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AccountSettingsGetOperation() }
    var put: OperationRepresentable? { AccountSettingsUpdateOperation() }
}
