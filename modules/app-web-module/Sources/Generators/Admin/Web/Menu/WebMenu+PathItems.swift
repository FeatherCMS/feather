import FeatherOpenAPI

struct WebMenuPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { WebMenuCreateOperation() }
    var delete: (any OperationRepresentable)? { WebMenuRemoveOperation() }
}

struct WebMenuSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { WebMenuSearchOperation() }
}

struct WebMenuListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { WebMenuListOperation() }
}

struct WebMenuIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { WebMenuGetOperation() }
    var put: (any OperationRepresentable)? { WebMenuUpdateOperation() }
    var patch: (any OperationRepresentable)? { WebMenuPatchOperation() }
}
