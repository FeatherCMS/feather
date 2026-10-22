public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeAddVariantProcessor() -> Variant.Processor.Add.UseCase {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(scope: { context in
                Variant.Processor.Add.Scope(
                    variantDefinitions: Variant.Repository.Database(
                        context: context
                    ),
                    variantProcessors: Variant.Processor.Repository.Database(
                        context: context
                    )
                )
            })
        )
    }
}
