public import FeatherOpenAPI

struct SettingsDetailResponse: JSONResponseRepresentable {
    var description: String = "Settings response"
    var schema = SettingsDetailSchema().reference()
}
