import FeatherOpenAPI
import WebOpenAPIGeneratorSupport

extension Menu.ID.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MenuDetailResponse" }
        var description: String = "Menu response"
        var schema = Schema().reference()
    }
}
