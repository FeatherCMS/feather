import FeatherOpenAPI

struct MediaVariantPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { MediaVariantCreateOperation() }
    var delete: (any OperationRepresentable)? { MediaVariantRemoveOperation() }
}

struct MediaVariantListPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { MediaVariantListOperation() }
}

struct MediaVariantIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { MediaVariantGetOperation() }
    var patch: (any OperationRepresentable)? { MediaVariantUpdateOperation() }
}

struct MediaVariantProcessorsPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? {
        MediaVariantProcessorCreateOperation()
    }
    var delete: (any OperationRepresentable)? {
        MediaVariantProcessorRemoveOperation()
    }
}

struct MediaVariantProcessorsListPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? {
        MediaVariantProcessorListOperation()
    }
}

struct MediaVariantProcessorIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? {
        MediaVariantProcessorGetOperation()
    }
    var patch: (any OperationRepresentable)? {
        MediaVariantProcessorUpdateOperation()
    }
}
