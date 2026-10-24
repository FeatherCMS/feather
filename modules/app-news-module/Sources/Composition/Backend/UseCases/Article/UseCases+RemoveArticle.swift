public import NewsApplication
public import NewsModule

extension UseCases {

    public func makeRemoveArticle() -> Article.Remove.UseCase {
        .init(authorizer: authorizer, transaction: articleRemoveTransaction())
    }
}
