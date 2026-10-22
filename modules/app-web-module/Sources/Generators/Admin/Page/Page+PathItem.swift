public import FeatherOpenAPI

extension Page {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { WebPageCreateOperation() }
        var delete: (any OperationRepresentable)? { WebPageRemoveOperation() }
    }
}
