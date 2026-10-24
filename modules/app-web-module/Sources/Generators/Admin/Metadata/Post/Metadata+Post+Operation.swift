import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension Metadata.Post {
    struct Operation: Metadata.Operation, BearerProtectedOperation {
        var operationId: String? { "metadataCreate" }
        var requestBody: (any RequestBodyRepresentable)? {
            MetadataRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                201: MetadataDetailResponse().reference()
            ]
        }
    }
}
