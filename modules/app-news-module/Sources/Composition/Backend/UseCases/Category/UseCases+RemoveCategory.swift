public import NewsApplication
public import NewsModule

extension UseCases {

    public func makeRemoveCategory() -> Category.Remove.UseCase {
        .init(
            authorizer: authorizer,
            transaction: categoryRemoveTransaction()
        )
    }
}
