import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct MetadataPatchOperation: MetadataIDOperation {
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
