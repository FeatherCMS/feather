import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension Metadata.Patch {
    struct Operation: Metadata.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "metadataPatch" }
        var requestBody: (any RequestBodyRepresentable)? {
            MetadataPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: MetadataDetailResponse().reference(),
                404: CustomResponse(description: "Metadata not found"),
            ]
        }
    }
}
