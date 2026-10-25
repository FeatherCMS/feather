import FeatherOpenAPI

extension Metadata.Input {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsMetadataInputSchema" }
        var propertyMap: SchemaMap {
            [
                "slug": Metadata.Schemas.StringField(),
                "status": Metadata.Schemas.StatusField(),
                "publicationDate": Metadata.Schemas.TimestampField()
                    .reference(required: false),
                "expirationDate": Metadata.Schemas.TimestampField()
                    .reference(required: false),
                "title": Metadata.Schemas.StringField()
                    .reference(required: false),
                "excerpt": Metadata.Schemas.StringField()
                    .reference(required: false),
                "imageURL": Metadata.Schemas.StringField()
                    .reference(required: false),
                "canonicalURL": Metadata.Schemas.StringField()
                    .reference(required: false),
                "noIndex": Metadata.Schemas.BooleanField()
                    .reference(required: false),
                "primaryKeyword": Metadata.Schemas.StringField()
                    .reference(required: false),
                "cssCodeInjection": Metadata.Schemas.StringField()
                    .reference(required: false),
                "javascriptCodeInjection": Metadata.Schemas.StringField()
                    .reference(required: false),
                "structuredDataCodeInjection": Metadata.Schemas.StringField()
                    .reference(required: false),
            ]
        }
    }
}
