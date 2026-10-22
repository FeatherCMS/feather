public import FeatherOpenAPI

extension Metadata {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { MetadataCreateOperation() }
        var delete: (any OperationRepresentable)? {
            MetadataRemoveOperation()
        }
    }
}
