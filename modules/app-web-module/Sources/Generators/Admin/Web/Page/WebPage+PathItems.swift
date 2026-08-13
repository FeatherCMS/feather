import FeatherOpenAPI

struct WebPagePathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebPageCreateOperation() }
}

struct WebPageSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebPageSearchOperation() }
}

struct WebPageFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebPageFiltersOperation() }
}

struct WebPageIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebPageGetOperation() }
    var put: OperationRepresentable? { WebPageUpdateOperation() }
    var patch: OperationRepresentable? { WebPagePatchOperation() }
    var delete: OperationRepresentable? { WebPageDeleteOperation() }
}
