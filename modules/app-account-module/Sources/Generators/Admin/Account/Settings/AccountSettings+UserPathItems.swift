import FeatherOpenAPI

struct AdminAccountSettingsPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AdminAccountSettingsGetOperation() }
    var put: OperationRepresentable? { AdminAccountSettingsUpdateOperation() }
}
