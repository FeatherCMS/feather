import FeatherOpenAPI

extension Settings {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { WebSettingsGetOperation() }
        var put: (any OperationRepresentable)? { WebSettingsUpdateOperation() }
    }
}
