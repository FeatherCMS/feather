public import NewsApplication
public import NewsModule

extension UseCases {

    public func makeEditCategory() -> Category.Edit.UseCase {
        .init(authorizer: authorizer, transaction: categoryEditTransaction())
    }
}
