import FeatherOpenAPI

struct BlogTagPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { BlogTagCreateOperation() }
    var delete: (any OperationRepresentable)? { BlogTagRemoveOperation() }
}

struct BlogTagSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { BlogTagSearchOperation() }
}

struct BlogTagListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { BlogTagListOperation() }
}

struct BlogTagIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { BlogTagGetOperation() }
    var put: (any OperationRepresentable)? { BlogTagUpdateOperation() }
    var patch: (any OperationRepresentable)? { BlogTagPatchOperation() }
}
