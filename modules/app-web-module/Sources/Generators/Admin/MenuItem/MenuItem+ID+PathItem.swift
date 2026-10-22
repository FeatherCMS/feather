public import FeatherOpenAPI

extension MenuItem.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { MenuItemGetOperation() }
        var put: (any OperationRepresentable)? { MenuItemUpdateOperation() }
        var patch: (any OperationRepresentable)? { MenuItemPatchOperation() }
    }
}
