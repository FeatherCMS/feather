import FeatherOpenAPI
import OpenAPIKit30

public struct BlogSettingsPostListPathField: StringSchemaRepresentable {
    public var example: String? = "blog"

    public init() {}
}

public struct BlogSettingsAuthorListPathField: StringSchemaRepresentable {
    public var example: String? = "authors"

    public init() {}
}

public struct BlogSettingsTagListPathField: StringSchemaRepresentable {
    public var example: String? = "tags"

    public init() {}
}

public struct BlogSettingsPostPathPrefixField: StringSchemaRepresentable {
    public var example: String? = "posts"

    public init() {}
}

public struct BlogSettingsAuthorPathPrefixField: StringSchemaRepresentable {
    public var example: String? = "authors"

    public init() {}
}

public struct BlogSettingsTagPathPrefixField: StringSchemaRepresentable {
    public var example: String? = "tags"

    public init() {}
}

public struct BlogSettingsSiteNoIndexField: BoolSchemaRepresentable {
    public var example: Bool? = false

    public init() {}
}

public struct BlogRouteSettingsSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "postListPath": BlogSettingsPostListPathField().reference(),
            "authorListPath": BlogSettingsAuthorListPathField().reference(),
            "tagListPath": BlogSettingsTagListPathField().reference(),
            "postPathPrefix": BlogSettingsPostPathPrefixField().reference(),
            "authorPathPrefix": BlogSettingsAuthorPathPrefixField().reference(),
            "tagPathPrefix": BlogSettingsTagPathPrefixField().reference(),
            "siteNoIndex": BlogSettingsSiteNoIndexField().reference(),
        ]
    }

    public init() {}
}
