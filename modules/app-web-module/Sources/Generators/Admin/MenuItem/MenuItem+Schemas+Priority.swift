import FeatherOpenAPI

extension MenuItem.Schemas {
    struct Priority: IntSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemPriorityField" }
        var example: Int? { 10 }
    }
}
