public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeEditVariant() -> Variant.Edit.UseCase {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(scope: { context in
                Variant.Edit.Scope(
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
