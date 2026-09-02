import FeatherOpenAPI

struct WebPagePathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebPageCreateOperation() }
    var delete: OperationRepresentable? { WebPageDeleteOperation() }
}

struct WebPageSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebPageSearchOperation() }
}

struct WebPageListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebPageListOperation() }
}

struct WebPageIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebPageGetOperation() }
    var put: OperationRepresentable? { WebPageUpdateOperation() }
    var patch: OperationRepresentable? { WebPagePatchOperation() }
}
