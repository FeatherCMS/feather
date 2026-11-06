import FeatherOpenAPI

extension MenuItem.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MenuItemListResponse" }
        var description: String = "MenuItem list response"
        var schema: some SchemaRepresentable { Schema().reference() }
    }
}
