import FeatherOpenAPI

struct BlogPostPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogPostCreateOperation() }
    var delete: OperationRepresentable? { BlogPostDeleteOperation() }
}

struct BlogPostSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogPostSearchOperation() }
}

struct BlogPostListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogPostListOperation() }
}

struct BlogPostIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogPostGetOperation() }
    var put: OperationRepresentable? { BlogPostUpdateOperation() }
    var patch: OperationRepresentable? { BlogPostPatchOperation() }
}
