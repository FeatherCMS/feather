import FeatherOpenAPI
import OpenAPIKit30

struct BlogSettingsIdField: StringSchemaRepresentable {
    var example: String? = "blog-settings"
}

struct BlogSettingsPostListPathField: StringSchemaRepresentable {
    var example: String? = "blog"
}

struct BlogSettingsAuthorListPathField: StringSchemaRepresentable {
    var example: String? = "authors"
}

struct BlogSettingsTagListPathField: StringSchemaRepresentable {
    var example: String? = "tags"
}

struct BlogSettingsPostPathPrefixField: StringSchemaRepresentable {
    var example: String? = "posts"
}

struct BlogSettingsAuthorPathPrefixField: StringSchemaRepresentable {
    var example: String? = "authors"
}

struct BlogSettingsTagPathPrefixField: StringSchemaRepresentable {
    var example: String? = "tags"
}

struct BlogSettingsUpdateSchema: ObjectSchemaRepresentable {
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

struct BlogSettingsDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": BlogSettingsIdField(),
            "postListPath": BlogSettingsPostListPathField(),
            "authorListPath": BlogSettingsAuthorListPathField(),
            "tagListPath": BlogSettingsTagListPathField(),
            "postPathPrefix": BlogSettingsPostPathPrefixField(),
            "authorPathPrefix": BlogSettingsAuthorPathPrefixField(),
            "tagPathPrefix": BlogSettingsTagPathPrefixField(),
        ]
    }
}
