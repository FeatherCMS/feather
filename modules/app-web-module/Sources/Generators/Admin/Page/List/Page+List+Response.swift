import FeatherOpenAPI
import WebOpenAPIGeneratorSupport

extension Page.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "PageListResponse" }
        var description: String = "Page list response"
        var schema = Schema().reference()
    }
}
