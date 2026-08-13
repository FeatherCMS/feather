import FeatherOpenAPI

struct WebSettingsDetailResponse: JSONResponseRepresentable {
    var description: String = "WebSettings response"
    var schema = WebSettingsDetailSchema().reference()
}
