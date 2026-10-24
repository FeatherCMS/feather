import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AccountSettingsDetailResponse" }
        var description: String = "Account settings"
        var schema = Schema().reference()
    }
}
