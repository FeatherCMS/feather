import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension Metadata.List {
    struct Operation: Metadata.Operation, BearerProtectedOperation {
        var operationId: String? { "metadataList" }
        var responseMap: ResponseMap {
            [
                200: MetadataListResponse().reference()
            ]
        }
    }
}
