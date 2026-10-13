import FeatherOpenAPI

struct WebPagePathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { WebPageCreateOperation() }
    var delete: (any OperationRepresentable)? { WebPageRemoveOperation() }
}

struct WebPageSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { WebPageSearchOperation() }
}

struct WebPageListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { WebPageListOperation() }
}

struct WebPageIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { WebPageGetOperation() }
    var put: (any OperationRepresentable)? { WebPageUpdateOperation() }
    var patch: (any OperationRepresentable)? { WebPagePatchOperation() }
}
