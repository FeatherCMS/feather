import FeatherOpenAPI

struct WebSettingsPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { WebSettingsGetOperation() }
    var put: (any OperationRepresentable)? { WebSettingsUpdateOperation() }
}
