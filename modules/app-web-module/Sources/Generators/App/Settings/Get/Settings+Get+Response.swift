import FeatherOpenAPI
import WebOpenAPIGeneratorSupport

extension Settings.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "SiteSettingsResponse" }
        var description: String = "Web site settings"
        var schema: some SchemaRepresentable {
            SiteSettingsSchema().reference()
        }
    }
}
