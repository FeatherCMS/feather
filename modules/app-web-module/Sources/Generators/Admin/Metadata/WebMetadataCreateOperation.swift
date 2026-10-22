import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

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
