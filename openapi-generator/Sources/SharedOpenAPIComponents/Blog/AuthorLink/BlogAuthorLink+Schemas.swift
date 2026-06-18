import FeatherOpenAPI
import OpenAPIKit30

public struct BlogAuthorLinkLabelField: StringSchemaRepresentable {
    public var example: String? = "Website"

    public init() {}
}

public struct BlogAuthorLinkURLField: StringSchemaRepresentable {
    public var example: String? = "https://example.com"

    public init() {}
}

public struct BlogAuthorLinkIsBlankField: BoolSchemaRepresentable {
    public var example: Bool? = false

    public init() {}
}

public struct BlogAuthorLinkListSchema: ArraySchemaRepresentable {
    public var items: SchemaRepresentable? {
        BlogAuthorLinkSchema().reference()
    }

    public init() {}
}

public struct BlogAuthorLinkSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "label": BlogAuthorLinkLabelField().reference(),
            "url": BlogAuthorLinkURLField().reference(),
            "isBlank": BlogAuthorLinkIsBlankField().reference(),
        ]
    }

    public init() {}
}
