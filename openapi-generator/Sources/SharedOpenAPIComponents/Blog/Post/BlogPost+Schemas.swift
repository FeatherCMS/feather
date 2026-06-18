import FeatherOpenAPI
import OpenAPIKit30

public struct BlogPostIdField: StringSchemaRepresentable {
    public var example: String? = "blog_post_1"

    public init() {}
}

public struct BlogPostContentField: StringSchemaRepresentable {
    public var example: String? = "<p>Hello world</p>"

    public init() {}
}

public struct BlogPostExcerptField: StringSchemaRepresentable {
    public var example: String? = "Short post summary."

    public init() {}
}

public struct BlogPostImageURLField: StringSchemaRepresentable {
    public var example: String? = "/media/assets/blog-post.png"

    public init() {}
}

public struct BlogPostSummaryListSchema: ArraySchemaRepresentable {
    public var items: SchemaRepresentable? {
        BlogPostSummarySchema().reference()
    }

    public init() {}
}

public struct BlogPostSummarySchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": BlogPostIdField().reference(),
            "excerpt": BlogPostExcerptField().reference(),
            "imageURL": BlogPostImageURLField().reference(),
            "media": MediaAssetSchema().reference(required: false),
            "metadata": WebMetadataContentSchema().reference(),
        ]
    }

    public init() {}
}

public struct BlogPostDetailSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": BlogPostIdField().reference(),
            "excerpt": BlogPostExcerptField().reference(),
            "content": BlogPostContentField().reference(),
            "imageURL": BlogPostImageURLField().reference(),
            "media": MediaAssetSchema().reference(required: false),
            "metadata": WebMetadataContentSchema().reference(),
            "authors": BlogAuthorSummaryListSchema().reference(),
            "tags": BlogTagSummaryListSchema().reference(),
        ]
    }

    public init() {}
}

public struct BlogPostListSchema: ArraySchemaRepresentable {
    public var items: SchemaRepresentable? {
        BlogPostSummarySchema().reference()
    }

    public init() {}
}
