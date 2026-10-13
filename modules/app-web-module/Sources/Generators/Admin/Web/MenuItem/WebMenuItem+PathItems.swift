import FeatherOpenAPI

struct WebMenuItemPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { WebMenuItemCreateOperation() }
    var delete: (any OperationRepresentable)? { WebMenuItemRemoveOperation() }
}

struct WebMenuItemSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { WebMenuItemSearchOperation() }
}

struct WebMenuItemListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { WebMenuItemListOperation() }
}

struct WebMenuItemIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { WebMenuItemGetOperation() }
    var put: (any OperationRepresentable)? { WebMenuItemUpdateOperation() }
    var patch: (any OperationRepresentable)? { WebMenuItemPatchOperation() }
}
