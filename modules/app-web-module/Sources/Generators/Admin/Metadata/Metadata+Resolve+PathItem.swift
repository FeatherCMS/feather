public import FeatherOpenAPI

extension Metadata.Resolve {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            MetadataResolveOperation()
        }
    }
}
