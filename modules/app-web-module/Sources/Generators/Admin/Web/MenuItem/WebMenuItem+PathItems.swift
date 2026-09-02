import FeatherOpenAPI

struct WebMenuItemPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMenuItemCreateOperation() }
    var delete: OperationRepresentable? { WebMenuItemDeleteOperation() }
}

struct WebMenuItemSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMenuItemSearchOperation() }
}

struct WebMenuItemListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMenuItemListOperation() }
}

struct WebMenuItemIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMenuItemGetOperation() }
    var put: OperationRepresentable? { WebMenuItemUpdateOperation() }
    var patch: OperationRepresentable? { WebMenuItemPatchOperation() }
}
