import FeatherOpenAPI
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct WebMetadataRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebMetadataCreateSchema().reference())
        ]
    }
}

struct WebMetadataUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebMetadataCreateSchema().reference())
        ]
    }
}

struct WebMetadataPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebMetadataPatchSchema().reference())
        ]
    }
}
