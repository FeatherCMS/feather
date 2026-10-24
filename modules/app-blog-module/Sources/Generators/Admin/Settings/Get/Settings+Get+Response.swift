import FeatherOpenAPI

extension Settings.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog settings response"
        var schema = Schema().reference()
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "postListPath": BlogSettingsPostListPathField(),
                "authorListPath": BlogSettingsAuthorListPathField(),
                "tagListPath": BlogSettingsTagListPathField(),
                "postPathPrefix": BlogSettingsPostPathPrefixField(),
                "authorPathPrefix": BlogSettingsAuthorPathPrefixField(),
                "tagPathPrefix": BlogSettingsTagPathPrefixField(),
            ]
        }
    }
}
