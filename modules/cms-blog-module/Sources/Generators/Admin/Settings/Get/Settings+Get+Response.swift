import FeatherOpenAPI

extension Settings.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog settings response"
        var schema = Schema().reference()
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
