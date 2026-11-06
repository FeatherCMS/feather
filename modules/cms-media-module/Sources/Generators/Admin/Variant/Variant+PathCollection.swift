import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/media/variants": PathItem(),
                "api/v1/admin/media/variants/query": Query.PathItem(),
                "api/v1/admin/media/variants/{mediaVariantId}":
                    ID.PathItem(),
                "api/v1/admin/media/variants/{mediaVariantId}/processors":
                    Processor.PathItem(),
                "api/v1/admin/media/variants/{mediaVariantId}/processors/query":
                    Processor.Query.PathItem(),
                "api/v1/admin/media/variants/{mediaVariantId}/processors/{mediaVariantProcessorId}":
                    Processor.ID.PathItem(),
            ]
        }
    }
}
