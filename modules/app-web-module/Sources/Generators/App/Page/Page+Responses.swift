import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

struct PageDetailResponse: JSONResponseRepresentable {
    var description: String = "Web page detail"
    var schema = PageDetailSchema().reference()

    init() {}
}
