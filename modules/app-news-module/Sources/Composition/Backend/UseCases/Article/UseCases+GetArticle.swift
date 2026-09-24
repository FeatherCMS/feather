public import NewsApplication

extension UseCases {

    public func makeGetArticle() -> GetArticle {
        .init(authorizer: authorizer, query: articleQuery())
    }
}
