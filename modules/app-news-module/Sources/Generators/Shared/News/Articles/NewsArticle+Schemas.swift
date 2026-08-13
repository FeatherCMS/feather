import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public struct NewsArticleIdField: StringSchemaRepresentable {
    public var example: String? = "news_1"

    public init() {}
}

public struct NewsArticleContentField: StringSchemaRepresentable {
    public var example: String? = "<p>Hello world</p>"

    public init() {}
}

public struct NewsArticleExcerptField: StringSchemaRepresentable {
    public var example: String? = "Short article summary."

    public init() {}
}

public struct NewsArticleImageURLField: StringSchemaRepresentable {
    public var example: String? = "/media/assets/news.png"

    public init() {}
}

public struct NewsArticleSummaryListSchema: ArraySchemaRepresentable {
    public var items: SchemaRepresentable? {
        NewsArticleSummarySchema().reference()
    }

    public init() {}
}

public struct NewsArticleSummarySchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": NewsArticleIdField().reference(),
            "excerpt": NewsArticleExcerptField().reference(),
            "imageURL": NewsArticleImageURLField().reference(),
            "media": MediaAssetSchema().reference(required: false),
            "metadata": WebMetadataContentSchema().reference(),
        ]
    }

    public init() {}
}

public struct NewsArticleDetailSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": NewsArticleIdField().reference(),
            "excerpt": NewsArticleExcerptField().reference(),
            "content": NewsArticleContentField().reference(),
            "imageURL": NewsArticleImageURLField().reference(),
            "media": MediaAssetSchema().reference(required: false),
            "metadata": WebMetadataContentSchema().reference(),
            "categories": NewsCategorySummaryListSchema().reference(),
        ]
    }

    public init() {}
}

public struct NewsArticleListSchema: ArraySchemaRepresentable {
    public var items: SchemaRepresentable? {
        NewsArticleSummarySchema().reference()
    }

    public init() {}
}
