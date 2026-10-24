public import NewsApplication
public import NewsModule

extension UseCases {

    public func makeAddArticle() -> Article.Add.UseCase {
        .init(
            authorizer: authorizer,
            transaction: articleAddTransaction()
        )
    }
}
