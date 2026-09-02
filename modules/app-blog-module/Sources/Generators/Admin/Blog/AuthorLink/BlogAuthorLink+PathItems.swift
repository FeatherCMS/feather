import FeatherOpenAPI

struct BlogAuthorLinkPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogAuthorLinkCreateOperation() }
    var delete: OperationRepresentable? { BlogAuthorLinkDeleteOperation() }
}

struct BlogAuthorLinkSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogAuthorLinkSearchOperation() }
}

struct BlogAuthorLinkListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogAuthorLinkListOperation() }
}

struct BlogAuthorLinkIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogAuthorLinkGetOperation() }
    var put: OperationRepresentable? { BlogAuthorLinkUpdateOperation() }
    var patch: OperationRepresentable? { BlogAuthorLinkPatchOperation() }
}
