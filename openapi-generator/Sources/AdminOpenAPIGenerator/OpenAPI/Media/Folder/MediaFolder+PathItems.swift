import FeatherOpenAPI

struct MediaFolderPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaFolderCreateOperation() }
}

struct MediaFolderSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaFolderSearchOperation() }
}

struct MediaFolderIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { MediaFolderGetOperation() }
    var patch: OperationRepresentable? { MediaFolderUpdateOperation() }
    var delete: OperationRepresentable? { MediaFolderDeleteOperation() }
}
