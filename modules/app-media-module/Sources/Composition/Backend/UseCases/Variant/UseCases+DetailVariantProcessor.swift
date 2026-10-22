public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeDetailVariantProcessor() -> Variant.Processor.Detail.UseCase
    {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(scope: { context in
                Variant.Processor.Detail.Scope(
                    variantProcessors: Variant.Processor.Repository.Database(
                        context: context
                    )
                )
            })
        )
    }
}
