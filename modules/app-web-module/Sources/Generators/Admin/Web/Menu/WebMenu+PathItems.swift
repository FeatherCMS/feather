import FeatherOpenAPI

struct WebMenuPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMenuCreateOperation() }
}

struct WebMenuSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMenuSearchOperation() }
}

struct WebMenuFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMenuFiltersOperation() }
}

struct WebMenuIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMenuGetOperation() }
    var put: OperationRepresentable? { WebMenuUpdateOperation() }
    var patch: OperationRepresentable? { WebMenuPatchOperation() }
    var delete: OperationRepresentable? { WebMenuDeleteOperation() }
}
