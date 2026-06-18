import FeatherOpenAPI
import SharedOpenAPIComponents

struct WebMetadataDetailResponse: JSONResponseRepresentable {
    var description: String = "WebMetadata response"
    var schema = WebMetadataDetailSchema().reference()
}

struct WebMetadataListResponse: JSONResponseRepresentable {
    var description: String = "WebMetadata list response"
    var schema = WebMetadataListSchema().reference()
}

struct WebMetadataFiltersResponse: JSONResponseRepresentable {
    var description: String = "WebMetadata filter response"
    var schema = SearchFilterSchema().reference()
}
