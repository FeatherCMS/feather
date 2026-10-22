public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeSearchVariants() -> Variant.Search.UseCase {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(scope: { context in
                Variant.Search.Scope(
                    variantDefinitions: Variant.Repository.Database(
                        context: context
                    )
                )
            })
        )
    }
}
