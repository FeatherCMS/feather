import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.ID.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MenuPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Menu.Schemas.Key().reference(required: false),
                "name": Menu.Schemas.Name().reference(required: false),
                "notes": Menu.Schemas.Notes().nullable()
                    .reference(
                        required: false
                    ),
            ]
        }
    }
}
