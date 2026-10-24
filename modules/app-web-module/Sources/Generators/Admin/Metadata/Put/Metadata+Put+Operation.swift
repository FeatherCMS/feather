import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Metadata.Put {
    struct Operation: Metadata.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "metadataUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            MetadataUpdateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: MetadataDetailResponse().reference(),
                404: CustomResponse(description: "Metadata not found"),
            ]
        }
    }
}
