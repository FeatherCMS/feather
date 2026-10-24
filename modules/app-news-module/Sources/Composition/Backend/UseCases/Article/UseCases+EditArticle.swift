public import NewsApplication
public import NewsModule

extension UseCases {

    public func makeEditArticle() -> Article.Edit.UseCase {
        .init(authorizer: authorizer, transaction: articleEditTransaction())
    }
}
