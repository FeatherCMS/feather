import FeatherDatabase
public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeSearchVariantProcessors()
        -> Variant.Processor.Search.UseCase
    {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Variant.Processor.Search.Scope(
                        query: Variant.Processor.Search.Query.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
