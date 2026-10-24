import FeatherOpenAPI

extension Article.Put {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "NewsArticleUpdateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Article.Schemas.Create().reference())]
        }
    }
}
