public import NewsApplication

extension UseCases {

    public func makeEditArticle() -> EditArticle {
        .init(authorizer: authorizer, transaction: articleTransaction())
    }
}
