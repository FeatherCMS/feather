import FeatherOpenAPI

struct AccountSettingsDetailResponse: JSONResponseRepresentable {
    var description: String = "Account settings response"
    var schema = AccountSettingsDetailSchema().reference()
}
