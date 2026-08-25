import FeatherOpenAPI

struct BlogPostPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogPostCreateOperation() }
    var delete: OperationRepresentable? { BlogPostBulkDeleteOperation() }
}

struct BlogPostSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogPostSearchOperation() }
}

struct BlogPostFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogPostFiltersOperation() }
}

struct BlogPostIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogPostGetOperation() }
    var put: OperationRepresentable? { BlogPostUpdateOperation() }
    var patch: OperationRepresentable? { BlogPostPatchOperation() }
}
