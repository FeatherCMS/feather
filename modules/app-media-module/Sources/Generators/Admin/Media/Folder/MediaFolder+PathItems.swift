import FeatherOpenAPI

struct MediaFolderPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaFolderCreateOperation() }
    var delete: OperationRepresentable? { MediaFolderDeleteOperation() }
}

struct MediaFolderSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaFolderSearchOperation() }
}

struct MediaFolderIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { MediaFolderGetOperation() }
    var patch: OperationRepresentable? { MediaFolderUpdateOperation() }
}
