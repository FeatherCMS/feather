public import NewsApplication
public import NewsModule

extension UseCases {

    public func makeGetArticle() -> Article.Detail.UseCase {
        .init(authorizer: authorizer, query: articleDetailQuery())
    }
}
