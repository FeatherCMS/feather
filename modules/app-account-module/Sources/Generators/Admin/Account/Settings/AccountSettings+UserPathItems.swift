import FeatherOpenAPI

struct AdminAccountSettingsPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? {
        AdminAccountSettingsGetOperation()
    }
    var put: (any OperationRepresentable)? {
        AdminAccountSettingsUpdateOperation()
    }
}
