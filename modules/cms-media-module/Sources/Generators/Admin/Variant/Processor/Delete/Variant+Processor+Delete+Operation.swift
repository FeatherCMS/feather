import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Processor.Delete {
    struct Operation: Variant.Processor.Operation, DeleteOperation {
        var operationId: String? { "mediaVariantProcessorDelete" }
    }
}
