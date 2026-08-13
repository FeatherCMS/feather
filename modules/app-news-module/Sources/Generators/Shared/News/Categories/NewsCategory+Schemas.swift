import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public struct NewsCategoryIdField: StringSchemaRepresentable {
    public var example: String? = "news_category_1"

    public init() {}
}

public struct NewsCategoryContentField: StringSchemaRepresentable {
    public var example: String? = "<p>News category description</p>"

    public init() {}
}

public struct NewsCategoryExcerptField: StringSchemaRepresentable {
    public var example: String? = "Short news category summary."

    public init() {}
}

public struct NewsCategoryImageURLField: StringSchemaRepresentable {
    public var example: String? = "/media/assets/news-category.png"

    public init() {}
}

public struct NewsCategorySummaryListSchema: ArraySchemaRepresentable {
    public var items: SchemaRepresentable? {
        NewsCategorySummarySchema().reference()
    }

    public init() {}
}

public struct NewsCategorySummarySchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": NewsCategoryIdField().reference(),
            "excerpt": NewsCategoryExcerptField().reference(),
            "imageURL": NewsCategoryImageURLField().reference(),
            "media": MediaAssetSchema().reference(required: false),
            "metadata": WebMetadataContentSchema().reference(),
        ]
    }

    public init() {}
}

public struct NewsCategoryDetailSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": NewsCategoryIdField().reference(),
            "excerpt": NewsCategoryExcerptField().reference(),
            "content": NewsCategoryContentField().reference(),
            "imageURL": NewsCategoryImageURLField().reference(),
            "media": MediaAssetSchema().reference(required: false),
            "metadata": WebMetadataContentSchema().reference(),
            "news": NewsArticleSummaryListSchema().reference(),
        ]
    }

    public init() {}
}

public struct NewsCategoryListSchema: ArraySchemaRepresentable {
    public var items: SchemaRepresentable? {
        NewsCategorySummarySchema().reference()
    }

    public init() {}
}
