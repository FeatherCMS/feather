import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata.Delete {
    struct Operation: Metadata.Operation, DeleteOperation {
        var operationId: String? { "metadataRemove" }
    }
}
