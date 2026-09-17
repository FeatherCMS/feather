import FeatherOpenAPI

struct BlogTagPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogTagCreateOperation() }
    var delete: OperationRepresentable? { BlogTagRemoveOperation() }
}

struct BlogTagSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { BlogTagSearchOperation() }
}

struct BlogTagListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogTagListOperation() }
}

struct BlogTagIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { BlogTagGetOperation() }
    var put: OperationRepresentable? { BlogTagUpdateOperation() }
    var patch: OperationRepresentable? { BlogTagPatchOperation() }
}
