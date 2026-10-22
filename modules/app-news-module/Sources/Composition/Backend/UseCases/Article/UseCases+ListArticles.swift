public import NewsApplication
public import NewsModule

extension UseCases {

    public func makeSearchArticles() -> Article.Search.UseCase {
        .init(authorizer: authorizer, query: articleSearchQuery())
    }

    public func makeListArticles() -> Article.List.UseCase {
        .init(authorizer: authorizer, query: articleListQuery())
    }
}
