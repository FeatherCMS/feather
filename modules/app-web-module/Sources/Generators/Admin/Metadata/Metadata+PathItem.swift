public import FeatherOpenAPI

extension Metadata {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { WebMetadataCreateOperation() }
        var delete: (any OperationRepresentable)? {
            WebMetadataRemoveOperation()
        }
    }
}
