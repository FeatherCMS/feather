public import NewsApplication

extension UseCases {

    public func makeRemoveArticle() -> RemoveArticle {
        .init(authorizer: authorizer, transaction: articleTransaction())
    }
}
