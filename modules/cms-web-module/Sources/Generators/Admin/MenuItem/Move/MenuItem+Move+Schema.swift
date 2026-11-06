import FeatherOpenAPI

extension MenuItem.Move {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemMoveSchema" }
        var propertyMap: SchemaMap {
            ["beforeItemId": MenuItem.Schemas.ID()]
        }
    }
}
