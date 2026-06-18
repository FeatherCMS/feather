import FeatherOpenAPI

struct BlogAuthorPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogAuthorCreateOperation() }
}

struct BlogAuthorSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogAuthorSearchOperation() }
}

struct BlogAuthorFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogAuthorFiltersOperation() }
}

struct BlogAuthorIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogAuthorGetOperation() }
    var put: OperationRepresentable? { BlogAuthorUpdateOperation() }
    var patch: OperationRepresentable? { BlogAuthorPatchOperation() }
    var delete: OperationRepresentable? { BlogAuthorDeleteOperation() }
}
