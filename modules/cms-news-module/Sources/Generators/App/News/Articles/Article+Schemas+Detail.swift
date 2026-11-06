public import FeatherOpenAPI

extension Article.Schemas {
    public struct Detail: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleDetailSchema" }
        public var propertyMap: SchemaMap {
            [
                "id": ID().reference(),
                "title": WebMetadata.Content.Schemas.Title().reference(),
                "excerpt": Excerpt().reference(),
                "content": Content().reference(),
                "imageURL": ImageURL().reference(),
                "media": Media.Asset.Schemas.Schema()
                    .reference(required: false),
                "metadata": WebMetadata.Content.Schema().reference(),
                "categories": Category.Schemas.SummaryList().reference(),
            ]
        }

        public init() {}
    }
}
