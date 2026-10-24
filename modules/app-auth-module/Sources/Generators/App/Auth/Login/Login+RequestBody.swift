import FeatherOpenAPI

extension Auth.Login {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(RequestSchema().reference())]
        }
    }

    struct RequestSchema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "email": Auth.Schemas.EmailField().reference(),
                "password": Auth.Schemas.PasswordField().reference(),
                "isPersistent": Auth.Schemas.IsPersistentField()
                    .reference(),
            ]
        }
    }
}
