import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

extension Metadata.List {
    struct Operation: Metadata.Operation {
        var operationId: String? { "webMetadataList" }
        var responseMap: ResponseMap {
            [200: WebMetadataListResponse().reference()]
        }
    }
}
