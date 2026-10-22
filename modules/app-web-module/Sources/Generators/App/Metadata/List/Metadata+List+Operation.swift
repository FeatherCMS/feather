import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

extension Metadata.List {
    struct Operation: Metadata.Operation {
        var operationId: String? { "metadataList" }
        var responseMap: ResponseMap {
            [200: MetadataListResponse().reference()]
        }
    }
}
