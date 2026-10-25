import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MenuItem.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MenuItemPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "label": MenuItem.Schemas.Label().reference(required: false),
                "url": MenuItem.Schemas.URL().reference(required: false),
                "priority": MenuItem.Schemas.Priority().reference(required: false),
                "isBlank": MenuItem.Schemas.IsBlank().reference(required: false),
                "permission": MenuItem.Schemas.Permission().reference(required: false),
                "authentication": MenuItem.Schemas.Authentication().reference(required: false),
                "notes": MenuItem.Schemas.Notes().nullable().reference(required: false),
            ]
        }
    }
}
