public import FeatherOpenAPI

extension MenuItem.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { WebMenuItemGetOperation() }
        var put: (any OperationRepresentable)? { WebMenuItemUpdateOperation() }
        var patch: (any OperationRepresentable)? { WebMenuItemPatchOperation() }
    }
}
