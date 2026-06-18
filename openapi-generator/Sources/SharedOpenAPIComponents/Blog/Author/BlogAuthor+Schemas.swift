import FeatherOpenAPI
import OpenAPIKit30

public struct BlogAuthorIdField: StringSchemaRepresentable {
    public var example: String? = "blog_author_1"

    public init() {}
}

public struct BlogAuthorNameField: StringSchemaRepresentable {
    public var example: String? = "Jane Doe"

    public init() {}
}

public struct BlogAuthorContentField: StringSchemaRepresentable {
    public var example: String? = "<p>Author bio</p>"

    public init() {}
}

public struct BlogAuthorExcerptField: StringSchemaRepresentable {
    public var example: String? = "Short author summary."

    public init() {}
}

public struct BlogAuthorImageURLField: StringSchemaRepresentable {
    public var example: String? = "/media/assets/author.png"

    public init() {}
}

public struct BlogAuthorSummaryListSchema: ArraySchemaRepresentable {
    public var items: SchemaRepresentable? {
        BlogAuthorSummarySchema().reference()
    }

    public init() {}
}

public struct BlogAuthorSummarySchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": BlogAuthorIdField().reference(),
            "name": BlogAuthorNameField().reference(),
            "excerpt": BlogAuthorExcerptField().reference(),
            "content": BlogAuthorContentField().reference(),
            "imageURL": BlogAuthorImageURLField().reference(),
            "media": MediaAssetSchema().reference(required: false),
            "metadata": WebMetadataContentSchema().reference(),
        ]
    }

    public init() {}
}

public struct BlogAuthorDetailSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": BlogAuthorIdField().reference(),
            "name": BlogAuthorNameField().reference(),
            "excerpt": BlogAuthorExcerptField().reference(),
            "content": BlogAuthorContentField().reference(),
            "imageURL": BlogAuthorImageURLField().reference(),
            "media": MediaAssetSchema().reference(required: false),
            "metadata": WebMetadataContentSchema().reference(),
            "links": BlogAuthorLinkListSchema().reference(),
            "posts": BlogPostSummaryListSchema().reference(),
        ]
    }

    public init() {}
}

public struct BlogAuthorListSchema: ArraySchemaRepresentable {
    public var items: SchemaRepresentable? {
        BlogAuthorSummarySchema().reference()
    }

    public init() {}
}
