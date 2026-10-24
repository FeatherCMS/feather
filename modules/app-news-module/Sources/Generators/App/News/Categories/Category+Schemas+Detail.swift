public import FeatherOpenAPI
import NewsOpenAPIGeneratorSupport
import OpenAPIKit30

public extension Category.Schemas {
    struct Detail: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryDetailSchema" }
        public var propertyMap: SchemaMap {
            [
                "id": ID().reference(),
                "title": WebMetadata.Content.Schemas.Title().reference(),
                "excerpt": Excerpt().reference(),
                "content": Content().reference(),
                "imageURL": ImageURL().reference(),
                "media": Media.Asset.Schemas.Schema().reference(required: false),
                "metadata": WebMetadata.Content.Schema().reference(),
                "news": Article.Schemas.SummaryList().reference(),
            ]
        }

        public init() {}
    }
}
