import FeatherOpenAPI

extension AuthorLink.Post {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "label": AuthorLink.Schemas.Label(),
                "url": AuthorLink.Schemas.URL(),
                "priority": AuthorLink.Schemas.Priority(),
                "isBlank": AuthorLink.Schemas.IsBlank(),
                "permission": AuthorLink.Schemas.Permission(),
                "notes": AuthorLink.Schemas.Notes().reference(required: false),
            ]
        }
    }
}
