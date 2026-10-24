public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeEditVariantProcessor() -> Variant.Processor.Edit.UseCase {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(scope: { context in
                Variant.Processor.Edit.Scope(
                    variantProcessors: Variant.Processor.Repository.Database(
                        context: context
                    )
                )
            })
        )
    }
}
