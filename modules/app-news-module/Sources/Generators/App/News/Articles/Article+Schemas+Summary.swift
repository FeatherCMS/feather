public import FeatherOpenAPI
import NewsOpenAPIGeneratorSupport

public extension Article.Schemas {
    struct Summary: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleSummarySchema" }
        public var propertyMap: SchemaMap {
            [
                "id": ID().reference(),
                "title": WebMetadata.Content.Schemas.Title().reference(),
                "excerpt": Excerpt().reference(),
                "imageURL": ImageURL().reference(),
                "media": Media.Asset.Schemas.Schema().reference(required: false),
                "metadata": WebMetadata.Content.Schema().reference(),
            ]
        }

        public init() {}
    }
}
