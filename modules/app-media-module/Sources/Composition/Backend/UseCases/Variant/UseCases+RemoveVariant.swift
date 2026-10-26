import FeatherInfrastructure
public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeRemoveVariant() -> Variant.Remove.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Variant.Remove.Scope(
                        variantDefinitions: Variant.Repository.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
