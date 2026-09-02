import FeatherOpenAPI

struct BlogAuthorPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogAuthorCreateOperation() }
    var delete: OperationRepresentable? { BlogAuthorDeleteOperation() }
}

struct BlogAuthorSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogAuthorSearchOperation() }
}

struct BlogAuthorListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogAuthorListOperation() }
}

struct BlogAuthorIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogAuthorGetOperation() }
    var put: OperationRepresentable? { BlogAuthorUpdateOperation() }
    var patch: OperationRepresentable? { BlogAuthorPatchOperation() }
}
