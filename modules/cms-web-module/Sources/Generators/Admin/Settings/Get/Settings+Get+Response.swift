import FeatherOpenAPI

extension Settings.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "SettingsDetailResponse" }
        var description: String = "Settings response"
        var schema: some SchemaRepresentable { Schema().reference() }
    }
}
