import FeatherOpenAPI

struct BlogSettingsDetailResponse: JSONResponseRepresentable {
    var description: String = "BlogSettings response"
    var schema = BlogSettingsDetailSchema().reference()
}
