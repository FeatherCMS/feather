import FeatherOpenAPI

struct MediaVariantPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaVariantCreateOperation() }
    var delete: OperationRepresentable? { MediaVariantRemoveOperation() }
}

struct MediaVariantListPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaVariantListOperation() }
}

struct MediaVariantIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { MediaVariantGetOperation() }
    var patch: OperationRepresentable? { MediaVariantUpdateOperation() }
}

struct MediaVariantProcessorsPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaVariantProcessorCreateOperation() }
    var delete: OperationRepresentable? { MediaVariantProcessorRemoveOperation() }
}

struct MediaVariantProcessorsListPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaVariantProcessorListOperation() }
}

struct MediaVariantProcessorIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { MediaVariantProcessorGetOperation() }
    var patch: OperationRepresentable? { MediaVariantProcessorUpdateOperation() }
}
