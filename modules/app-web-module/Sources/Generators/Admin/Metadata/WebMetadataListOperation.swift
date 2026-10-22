import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

struct WebMetadataListOperation: WebMetadataOperation {
    var responseMap: ResponseMap {
        [
            200: WebMetadataListResponse().reference()
        ]
    }
}
