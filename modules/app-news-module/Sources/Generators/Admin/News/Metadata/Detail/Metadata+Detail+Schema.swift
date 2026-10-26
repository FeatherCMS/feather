import FeatherOpenAPI

extension Metadata.Detail {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsMetadataDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Metadata.Schemas.StringField(),
                "referenceType": Metadata.Schemas.StringField(),
                "referenceID": Metadata.Schemas.StringField(),
                "slug": Metadata.Schemas.StringField(),
                "template": Metadata.Schemas.StringField(),
                "publicationDate": Metadata.Schemas.TimestampField(),
                "expirationDate": Metadata.Schemas.TimestampField()
                    .reference(required: false),
                "status": Metadata.Schemas.StatusField(),
                "title": Metadata.Schemas.StringField()
                    .reference(required: false),
                "excerpt": Metadata.Schemas.StringField()
                    .reference(required: false),
                "imageURL": Metadata.Schemas.StringField()
                    .reference(required: false),
                "canonicalURL": Metadata.Schemas.StringField()
                    .reference(required: false),
                "noIndex": Metadata.Schemas.BooleanField(),
                "primaryKeyword": Metadata.Schemas.StringField()
                    .reference(required: false),
                "cssCodeInjection": Metadata.Schemas.StringField()
                    .reference(required: false),
                "javascriptCodeInjection": Metadata.Schemas.StringField()
                    .reference(required: false),
                "structuredDataCodeInjection": Metadata.Schemas.StringField()
                    .reference(required: false),
                "createdAt": Metadata.Schemas.TimestampField(),
                "updatedAt": Metadata.Schemas.TimestampField(),
            ]
        }
    }
}
