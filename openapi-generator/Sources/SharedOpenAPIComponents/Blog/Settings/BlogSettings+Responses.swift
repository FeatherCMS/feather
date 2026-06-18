import FeatherOpenAPI

public struct BlogRouteSettingsResponse: JSONResponseRepresentable {
    public var description: String = "Blog route settings"
    public var schema = BlogRouteSettingsSchema().reference()

    public init() {}
}
