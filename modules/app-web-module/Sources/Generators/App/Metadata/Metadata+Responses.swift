import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

struct MetadataResponse: JSONResponseRepresentable {
    var description: String = "Web metadata resolution"
    var schema = MetadataSchema().reference()

    init() {}
}

struct MetadataListResponse: JSONResponseRepresentable {
    var description: String = "Public web metadata slugs"
    var schema = MetadataSlugListSchema().reference()

    init() {}
}
