import FeatherOpenAPI

extension Asset.File.Variant.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
