public import NewsApplication

extension UseCases {

    public func makeListArticles() -> ListArticles {
        .init(authorizer: authorizer, query: articleQuery())
    }
}
