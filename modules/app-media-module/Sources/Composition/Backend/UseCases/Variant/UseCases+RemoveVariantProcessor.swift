import FeatherInfrastructure
public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeRemoveVariantProcessor() -> Variant.Processor.Remove.UseCase
    {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Variant.Processor.Remove.Scope(
                        variantProcessors: Variant.Processor.Repository
                            .Database(
                                context: context
                            )
                    )
                }
            )
        )
    }
}
