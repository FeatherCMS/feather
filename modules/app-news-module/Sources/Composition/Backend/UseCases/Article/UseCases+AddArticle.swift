public import NewsApplication

extension UseCases {

    public func makeAddArticle() -> AddArticle {
        .init(
            authorizer: authorizer,
            transaction: articleTransaction()
        )
    }
}
