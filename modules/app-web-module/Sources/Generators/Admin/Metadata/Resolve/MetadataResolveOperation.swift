import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct MetadataResolveOperation: MetadataOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        MetadataResolveRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: MetadataResolveResponse().reference()
        ]
    }
}
