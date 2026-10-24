import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension Metadata.Delete {
    struct Operation: Metadata.Operation, DeleteOperation {
        var operationId: String? { "metadataRemove" }
    }
}
