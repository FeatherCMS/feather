import FeatherOpenAPI

struct BlogAuthorLinkPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { BlogAuthorLinkCreateOperation() }
    var delete: (any OperationRepresentable)? {
        BlogAuthorLinkRemoveOperation()
    }
}

struct BlogAuthorLinkSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { BlogAuthorLinkSearchOperation() }
}

struct BlogAuthorLinkListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { BlogAuthorLinkListOperation() }
}

struct BlogAuthorLinkIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { BlogAuthorLinkGetOperation() }
    var put: (any OperationRepresentable)? { BlogAuthorLinkUpdateOperation() }
    var patch: (any OperationRepresentable)? { BlogAuthorLinkPatchOperation() }
}
