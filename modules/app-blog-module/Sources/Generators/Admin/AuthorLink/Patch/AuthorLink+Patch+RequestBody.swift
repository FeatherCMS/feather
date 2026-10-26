import FeatherOpenAPI

extension AuthorLink.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "label": AuthorLink.Schemas.Label().reference(required: false),
                "url": AuthorLink.Schemas.URL().reference(required: false),
                "priority": AuthorLink.Schemas.Priority()
                    .reference(required: false),
                "isBlank": AuthorLink.Schemas.IsBlank()
                    .reference(required: false),
                "permission": AuthorLink.Schemas.Permission()
                    .reference(required: false),
                "notes": AuthorLink.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
