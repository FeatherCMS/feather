public import NewsApplication
public import NewsModule

extension UseCases {

    public func makeSearchCategories() -> Category.Search.UseCase {
        .init(authorizer: authorizer, query: categorySearchQuery())
    }

    public func makeListCategories() -> Category.List.UseCase {
        .init(authorizer: authorizer, query: categoryListQuery())
    }
}
