import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct WebMetadataCreateOperation: WebMetadataOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        WebMetadataRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: WebMetadataDetailResponse().reference()
        ]
    }
}
