import FeatherOpenAPI

extension Article.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "NewsArticleIDParameter" }
        var name: String { "newsArticleId" }
        var description: String? { "News article identifier" }
        var schema: any OpenAPISchemaRepresentable {
            Article.Schemas.StringField().reference()
        }
    }
}
