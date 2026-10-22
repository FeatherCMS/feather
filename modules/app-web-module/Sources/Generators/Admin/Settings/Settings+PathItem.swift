public import FeatherOpenAPI

extension Settings {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { SettingsGetOperation() }
        var put: (any OperationRepresentable)? { SettingsUpdateOperation() }
    }
}
