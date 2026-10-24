import FeatherOpenAPI
import OpenAPIKit30

extension Auth.MagicLink {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(RequestSchema().reference())]
        }
    }

    struct RequestSchema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "email": Auth.Schemas.EmailField().reference(),
                "isPersistent": Auth.Schemas.IsPersistentField()
                    .reference(),
            ]
        }
    }
}
