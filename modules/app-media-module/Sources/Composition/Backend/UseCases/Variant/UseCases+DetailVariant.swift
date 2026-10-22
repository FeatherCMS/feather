public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeDetailVariant() -> Variant.Detail.UseCase {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(scope: { context in
                Variant.Detail.Scope(
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
