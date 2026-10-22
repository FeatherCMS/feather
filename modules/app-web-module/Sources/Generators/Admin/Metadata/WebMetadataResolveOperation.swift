import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

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
