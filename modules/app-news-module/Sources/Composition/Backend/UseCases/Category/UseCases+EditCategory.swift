import NewsApplication

extension UseCases {

    public func makeEditCategory() -> EditCategory {
        .init(authorizer: authorizer, transaction: categoryTransaction())
    }
}
