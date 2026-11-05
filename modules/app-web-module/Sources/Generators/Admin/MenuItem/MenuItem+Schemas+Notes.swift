import FeatherOpenAPI

extension MenuItem.Schemas {
    struct Notes: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemNotesField" }
        var example: String? { "Visible for all visitors." }
    }
}
