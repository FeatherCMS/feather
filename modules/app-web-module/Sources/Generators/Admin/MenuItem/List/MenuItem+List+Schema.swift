import FeatherOpenAPI

extension MenuItem.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemListSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }
}
