import FeatherOpenAPI

struct BlogPostPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { BlogPostCreateOperation() }
    var delete: (any OperationRepresentable)? { BlogPostRemoveOperation() }
}

struct BlogPostSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { BlogPostSearchOperation() }
}

struct BlogPostListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { BlogPostListOperation() }
}

struct BlogPostIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { BlogPostGetOperation() }
    var put: (any OperationRepresentable)? { BlogPostUpdateOperation() }
    var patch: (any OperationRepresentable)? { BlogPostPatchOperation() }
}
