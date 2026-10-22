import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct MetadataCreateOperation: MetadataOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        MetadataRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: MetadataDetailResponse().reference()
        ]
    }
}
