import FeatherOpenAPI

struct NewsArticleIDParameter: PathParameterRepresentable {
    var name: String { "newsArticleId" }
    var description: String? { "News article identifier" }
    var schema: any OpenAPISchemaRepresentable {
        NewsAdminOpenAPIComponents.StringField().reference()
    }
}
