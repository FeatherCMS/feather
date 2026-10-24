public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeAddVariant() -> Variant.Add.UseCase {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(scope: { context in
                Variant.Add.Scope(
                    variantDefinitions: Variant.Repository.Database(
                        context: context
                    )
                )
            })
        )
    }
}
