import FeatherOpenAPI

extension Metadata.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { WebMetadataListOperation() }
    }
}
