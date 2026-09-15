import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

struct WebMetadataDetailResponse: JSONResponseRepresentable {
    var description: String = "WebMetadata response"
    var schema = WebMetadataDetailSchema().reference()
}

struct WebMetadataListResponse: JSONResponseRepresentable {
    var description: String = "WebMetadata list response"
    var schema = WebMetadataListSchema().reference()
}

struct WebMetadataLookupResponse: JSONResponseRepresentable {
    var description: String = "WebMetadata lookup response"
    var schema = WebMetadataLookupSchema().reference()
}
