import FeatherOpenAPI

struct WebMenuItemPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMenuItemCreateOperation() }
}

struct WebMenuItemSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMenuItemSearchOperation() }
}

struct WebMenuItemFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMenuItemFiltersOperation() }
}

struct WebMenuItemIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMenuItemGetOperation() }
    var put: OperationRepresentable? { WebMenuItemUpdateOperation() }
    var patch: OperationRepresentable? { WebMenuItemPatchOperation() }
    var delete: OperationRepresentable? { WebMenuItemDeleteOperation() }
}
