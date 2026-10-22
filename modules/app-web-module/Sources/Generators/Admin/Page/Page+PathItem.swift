public import FeatherOpenAPI

extension Page {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { PageCreateOperation() }
        var delete: (any OperationRepresentable)? { PageRemoveOperation() }
    }
}
