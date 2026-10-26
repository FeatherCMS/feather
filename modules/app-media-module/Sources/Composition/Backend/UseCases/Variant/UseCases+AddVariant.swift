import FeatherInfrastructure
public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeAddVariant() -> Variant.Add.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Variant.Add.Scope(
                        variantDefinitions: Variant.Repository.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
