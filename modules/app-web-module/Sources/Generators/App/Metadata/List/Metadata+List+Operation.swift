import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata.List {
    struct Operation: Metadata.Operation {
        var operationId: String? { "metadataList" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
