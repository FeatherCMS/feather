import FeatherOpenAPI

extension Asset.File.Variant.Query {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
