import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

struct MenuListResponse: JSONResponseRepresentable {
    var description: String = "Web menu list"
    var schema = MenuListSchema().reference()

    init() {}
}

struct MenuResponse: JSONResponseRepresentable {
    var description: String = "Web menu"
    var schema = MenuSchema().reference()

    init() {}
}
