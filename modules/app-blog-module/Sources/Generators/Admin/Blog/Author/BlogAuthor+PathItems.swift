import FeatherOpenAPI

struct BlogAuthorPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { BlogAuthorCreateOperation() }
    var delete: (any OperationRepresentable)? { BlogAuthorRemoveOperation() }
}

struct BlogAuthorSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { BlogAuthorSearchOperation() }
}

struct BlogAuthorListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { BlogAuthorListOperation() }
}

struct BlogAuthorIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { BlogAuthorGetOperation() }
    var put: (any OperationRepresentable)? { BlogAuthorUpdateOperation() }
    var patch: (any OperationRepresentable)? { BlogAuthorPatchOperation() }
}
