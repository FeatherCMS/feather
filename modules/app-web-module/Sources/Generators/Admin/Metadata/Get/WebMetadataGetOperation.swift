import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct WebMetadataGetOperation: WebMetadataIDOperation {
    var responseMap: ResponseMap {
        [
            200: WebMetadataDetailResponse().reference(),
            404: CustomResponse(description: "WebMetadata not found"),
        ]
    }
}
