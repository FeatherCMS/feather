public import NewsApplication

extension UseCases {

    public func makeRemoveCategory() -> RemoveCategory {
        .init(
            authorizer: authorizer,
            transaction: categoryArticlesTransaction()
        )
    }
}
