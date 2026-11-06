import FeatherOpenAPI

extension Settings.Put {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "postListPath": Settings.Schemas.PostListPath(),
                "authorListPath": Settings.Schemas.AuthorListPath(),
                "tagListPath": Settings.Schemas.TagListPath(),
                "postPathPrefix": Settings.Schemas.PostPathPrefix(),
                "authorPathPrefix": Settings.Schemas.AuthorPathPrefix(),
                "tagPathPrefix": Settings.Schemas.TagPathPrefix(),
            ]
        }
    }
}
