import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct MetadataListOperation: MetadataOperation {
    var responseMap: ResponseMap {
        [
            200: MetadataListResponse().reference()
        ]
    }
}
