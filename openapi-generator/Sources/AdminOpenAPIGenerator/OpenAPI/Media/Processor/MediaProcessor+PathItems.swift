import FeatherOpenAPI

struct MediaProcessorPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaProcessorCreateOperation() }
}

struct MediaProcessorSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaProcessorSearchOperation() }
}

struct MediaProcessorIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { MediaProcessorGetOperation() }
    var patch: OperationRepresentable? { MediaProcessorUpdateOperation() }
    var delete: OperationRepresentable? { MediaProcessorDeleteOperation() }
}
