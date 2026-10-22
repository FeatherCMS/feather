import BlogSharedOpenAPIGenerator
import FeatherOpenAPI

extension Settings.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog route settings"
        var schema = BlogRouteSettingsSchema().reference()
    }
}
