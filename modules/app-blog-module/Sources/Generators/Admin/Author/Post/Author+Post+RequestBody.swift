import FeatherOpenAPI

extension Author.Post {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "name": Author.Schemas.Name(),
                "excerpt": Author.Schemas.Excerpt().reference(required: false),
                "content": Author.Schemas.Content().reference(required: false),
                "profileImageAssetId": Author.Schemas.ProfileImageAssetID()
                    .reference(required: false),
            ]
        }
    }
}
