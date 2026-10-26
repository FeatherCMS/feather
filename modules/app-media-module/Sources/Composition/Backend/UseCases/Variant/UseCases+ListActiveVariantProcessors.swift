import FeatherDatabase
import FeatherInfrastructure
public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeListActiveVariantProcessors()
        -> Variant.Processor.List.UseCase
    {
        .init(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Variant.Processor.List.Scope(
                        query: Variant.Processor.List.Query.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
