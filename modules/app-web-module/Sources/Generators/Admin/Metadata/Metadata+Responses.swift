public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

struct MetadataDetailResponse: JSONResponseRepresentable {
    var description: String = "Metadata response"
    var schema = MetadataDetailSchema().reference()
}

struct MetadataListResponse: JSONResponseRepresentable {
    var description: String = "Metadata list response"
    var schema = MetadataListSchema().reference()
}

struct MetadataResolveResponse: JSONResponseRepresentable {
    var description: String = "Metadata resolve response"
    var schema = MetadataResolveSchema().reference()
}
