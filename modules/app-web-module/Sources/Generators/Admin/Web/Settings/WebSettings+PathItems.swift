import FeatherOpenAPI

struct WebSettingsPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebSettingsGetOperation() }
    var put: OperationRepresentable? { WebSettingsUpdateOperation() }
}
