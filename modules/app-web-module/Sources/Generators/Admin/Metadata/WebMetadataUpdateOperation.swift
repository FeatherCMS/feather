import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

struct WebMetadataUpdateOperation: WebMetadataIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        WebMetadataUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: WebMetadataDetailResponse().reference(),
            404: CustomResponse(description: "WebMetadata not found"),
        ]
    }
}
