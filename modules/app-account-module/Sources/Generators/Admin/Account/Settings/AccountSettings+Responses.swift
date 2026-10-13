import FeatherOpenAPI

struct AccountSettingsDetailResponse: JSONResponseRepresentable {
    var description: String = "Account settings"
    var schema = AccountSettingsDetailSchema().reference()
}
