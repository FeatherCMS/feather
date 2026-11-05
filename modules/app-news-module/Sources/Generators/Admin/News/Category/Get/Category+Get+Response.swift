import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Category.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "NewsCategoryDetailResponse" }
        var description: String = "News category response"
        var schema = Schema().reference()
    }
}
