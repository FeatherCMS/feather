import FeatherDatabase
import FeatherInfrastructure
public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeDetailVariantProcessor() -> Variant.Processor.Detail.UseCase
    {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Variant.Processor.Detail.Scope(
                        query: Variant.Processor.Detail.Query.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
