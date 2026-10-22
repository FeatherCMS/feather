import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct WebMetadataListOperation: WebMetadataOperation {
    var responseMap: ResponseMap {
        [
            200: WebMetadataListResponse().reference()
        ]
    }
}
