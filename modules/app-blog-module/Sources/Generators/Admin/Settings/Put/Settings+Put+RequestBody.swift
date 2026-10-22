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
