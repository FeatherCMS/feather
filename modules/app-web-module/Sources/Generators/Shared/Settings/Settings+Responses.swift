public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct SiteSettingsResponse: JSONResponseRepresentable {
    public var description: String = "Web site settings"
    public var schema = SiteSettingsSchema().reference()

    public init() {}
}
