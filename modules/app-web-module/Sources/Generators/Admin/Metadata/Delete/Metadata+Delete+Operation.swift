import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Metadata.Delete {
    struct Operation: Metadata.Operation, DeleteOperation {
        var operationId: String? { "metadataRemove" }
    }
}
