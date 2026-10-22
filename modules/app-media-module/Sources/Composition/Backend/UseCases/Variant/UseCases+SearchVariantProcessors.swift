public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeSearchVariantProcessors()
        -> Variant.Processor.Search.UseCase
    {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(scope: { context in
                Variant.Processor.Search.Scope(
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
