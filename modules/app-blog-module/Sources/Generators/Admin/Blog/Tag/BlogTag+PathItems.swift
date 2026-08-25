import FeatherOpenAPI

struct BlogTagPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogTagCreateOperation() }
    var delete: OperationRepresentable? { BlogTagBulkDeleteOperation() }
}

struct BlogTagSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogTagSearchOperation() }
}

struct BlogTagFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogTagFiltersOperation() }
}

struct BlogTagIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogTagGetOperation() }
    var put: OperationRepresentable? { BlogTagUpdateOperation() }
    var patch: OperationRepresentable? { BlogTagPatchOperation() }
}
