import FeatherOpenAPI

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
