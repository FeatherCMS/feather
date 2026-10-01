import FeatherOpenAPI

struct BlogSettingsPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { BlogSettingsGetOperation() }
    var put: (any OperationRepresentable)? { BlogSettingsUpdateOperation() }
}
