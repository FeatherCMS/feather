public import NewsApplication
public import NewsModule

extension UseCases {

    public func makeGetCategory() -> Category.Detail.UseCase {
        .init(authorizer: authorizer, query: categoryDetailQuery())
    }
}
