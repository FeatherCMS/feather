public import FeatherOpenAPI
import FeatherOpenAPIGenerator
public import OpenAPIKit30

public struct BlogTagIdField: StringSchemaRepresentable {
    public var example: String? = "blog_tag_1"

    public init() {}
}

public struct BlogTagContentField: StringSchemaRepresentable {
    public var example: String? = "<p>Tag description</p>"

    public init() {}
}

public struct BlogTagExcerptField: StringSchemaRepresentable {
    public var example: String? = "Short tag summary."

    public init() {}
}

public struct BlogTagImageURLField: StringSchemaRepresentable {
    public var example: String? = "/123456789/originals/tag.png"

    public init() {}
}

public struct BlogTagSummaryListSchema: ArraySchemaRepresentable {
    public var items: (any SchemaRepresentable)? {
        BlogTagSummarySchema().reference()
    }

    public init() {}
}

public struct BlogTagSummarySchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": BlogTagIdField().reference(),
            "excerpt": BlogTagExcerptField().reference(),
            "imageURL": BlogTagImageURLField().reference(),
            "media": MediaAssetSchema().reference(required: false),
            "metadata": WebMetadataContentSchema().reference(),
        ]
    }

    public init() {}
}

public struct BlogTagDetailSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": BlogTagIdField().reference(),
            "excerpt": BlogTagExcerptField().reference(),
            "content": BlogTagContentField().reference(),
            "imageURL": BlogTagImageURLField().reference(),
            "media": MediaAssetSchema().reference(required: false),
            "metadata": WebMetadataContentSchema().reference(),
            "posts": BlogPostSummaryListSchema().reference(),
        ]
    }

    public init() {}
}

public struct BlogTagListSchema: ArraySchemaRepresentable {
    public var items: (any SchemaRepresentable)? {
        BlogTagSummarySchema().reference()
    }

    public init() {}
}
