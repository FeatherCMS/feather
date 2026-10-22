import FeatherOpenAPI

extension Page.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { WebPageGetOperation() }
        var put: (any OperationRepresentable)? { WebPageUpdateOperation() }
        var patch: (any OperationRepresentable)? { WebPagePatchOperation() }
    }
}
