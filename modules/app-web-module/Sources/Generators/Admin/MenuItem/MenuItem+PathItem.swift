public import FeatherOpenAPI

extension MenuItem {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { MenuItemCreateOperation() }
        var delete: (any OperationRepresentable)? {
            MenuItemRemoveOperation()
        }
    }
}
