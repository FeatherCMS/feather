public import NewsApplication

extension UseCases {

    public func makeAddCategory() -> AddCategory {
        .init(
            authorizer: authorizer,
            transaction: categoryTransaction()
        )
    }
}
