import FeatherOpenAPI

struct BlogSettingsPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogSettingsGetOperation() }
    var put: OperationRepresentable? { BlogSettingsUpdateOperation() }
}
