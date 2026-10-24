import FeatherOpenAPI

extension Article.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "NewsArticleRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Article.Schemas.Create().reference())]
        }
    }
}
