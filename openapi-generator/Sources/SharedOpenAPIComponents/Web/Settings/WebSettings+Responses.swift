import FeatherOpenAPI

public struct WebSiteSettingsResponse: JSONResponseRepresentable {
    public var description: String = "Web site settings"
    public var schema = WebSiteSettingsSchema().reference()

    public init() {}
}
