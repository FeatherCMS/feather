public import NewsApplication

extension UseCases {

    public func makeGetCategory() -> GetCategory {
        .init(authorizer: authorizer, query: categoryQuery())
    }
}
