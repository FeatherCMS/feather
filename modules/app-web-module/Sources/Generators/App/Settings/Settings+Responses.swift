import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

struct SiteSettingsResponse: JSONResponseRepresentable {
    var description: String = "Web site settings"
    var schema = SiteSettingsSchema().reference()

    init() {}
}
