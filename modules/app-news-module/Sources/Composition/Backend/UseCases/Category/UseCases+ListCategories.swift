import NewsApplication

extension UseCases {

    public func makeListCategories() -> ListCategories {
        .init(authorizer: authorizer, query: categoryQuery())
    }
}
