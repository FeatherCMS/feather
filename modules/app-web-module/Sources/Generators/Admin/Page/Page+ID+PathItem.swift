public import FeatherOpenAPI

extension Page.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { PageGetOperation() }
        var put: (any OperationRepresentable)? { PageUpdateOperation() }
        var patch: (any OperationRepresentable)? { PagePatchOperation() }
    }
}
