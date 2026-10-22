public import FeatherOpenAPI

extension MenuItem {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { WebMenuItemCreateOperation() }
        var delete: (any OperationRepresentable)? {
            WebMenuItemRemoveOperation()
        }
    }
}
