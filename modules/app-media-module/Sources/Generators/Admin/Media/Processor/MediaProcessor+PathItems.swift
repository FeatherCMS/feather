import FeatherOpenAPI

struct MediaProcessorPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaProcessorCreateOperation() }
    var delete: OperationRepresentable? { MediaProcessorRemoveOperation() }
}

struct MediaProcessorListPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaProcessorListOperation() }
}

struct MediaProcessorIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { MediaProcessorGetOperation() }
    var patch: OperationRepresentable? { MediaProcessorUpdateOperation() }
}
