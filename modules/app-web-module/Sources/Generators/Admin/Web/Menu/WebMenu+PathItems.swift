import FeatherOpenAPI

struct WebMenuPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMenuCreateOperation() }
    var delete: OperationRepresentable? { WebMenuDeleteOperation() }
}

struct WebMenuSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMenuSearchOperation() }
}

struct WebMenuListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMenuListOperation() }
}

struct WebMenuIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMenuGetOperation() }
    var put: OperationRepresentable? { WebMenuUpdateOperation() }
    var patch: OperationRepresentable? { WebMenuPatchOperation() }
}
