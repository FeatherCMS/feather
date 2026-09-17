import FeatherOpenAPI

struct MediaFolderPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaFolderCreateOperation() }
}

struct MediaFolderListPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaFolderListOperation() }
}

struct MediaFolderIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { MediaFolderGetOperation() }
    var patch: OperationRepresentable? { MediaFolderUpdateOperation() }
}
