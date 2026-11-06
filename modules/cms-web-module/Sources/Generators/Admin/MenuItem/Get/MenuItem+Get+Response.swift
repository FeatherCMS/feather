import FeatherOpenAPI

extension MenuItem.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MenuItemDetailResponse" }
        var description: String = "MenuItem response"
        var schema: some SchemaRepresentable { Schema().reference() }
    }
}
