import FeatherOpenAPI

struct MediaFolderPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { MediaFolderCreateOperation() }
}

struct MediaFolderListPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { MediaFolderListOperation() }
}

struct MediaFolderIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { MediaFolderGetOperation() }
    var patch: (any OperationRepresentable)? { MediaFolderUpdateOperation() }
}
