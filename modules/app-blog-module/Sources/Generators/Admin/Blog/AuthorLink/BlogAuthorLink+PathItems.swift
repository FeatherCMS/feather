import FeatherOpenAPI

struct BlogAuthorLinkPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogAuthorLinkCreateOperation() }
}

struct BlogAuthorLinkSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogAuthorLinkSearchOperation() }
}

struct BlogAuthorLinkFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogAuthorLinkFiltersOperation() }
}

struct BlogAuthorLinkIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogAuthorLinkGetOperation() }
    var put: OperationRepresentable? { BlogAuthorLinkUpdateOperation() }
    var patch: OperationRepresentable? { BlogAuthorLinkPatchOperation() }
    var delete: OperationRepresentable? { BlogAuthorLinkDeleteOperation() }
}
