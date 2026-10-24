import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Category.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "NewsCategoryListResponse" }
        var description: String = "News category list response"
        var schema = Schema().reference()
    }
}
