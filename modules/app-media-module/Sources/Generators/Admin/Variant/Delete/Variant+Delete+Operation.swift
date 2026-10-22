import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Delete {
    struct Operation: Variant.Operation, DeleteOperation {
        var operationId: String? { "mediaVariantDelete" }
    }
}
