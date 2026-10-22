public import NewsApplication
public import NewsModule

extension UseCases {

    public func makeAddCategory() -> Category.Add.UseCase {
        .init(
            authorizer: authorizer,
            transaction: categoryAddTransaction()
        )
    }
}
