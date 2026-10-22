import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct WebMetadataResolveOperation: WebMetadataOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        WebMetadataResolveRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebMetadataResolveResponse().reference()
        ]
    }
}
