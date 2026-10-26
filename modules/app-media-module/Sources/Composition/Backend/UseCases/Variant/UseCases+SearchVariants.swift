import FeatherDatabase
import FeatherInfrastructure
public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeSearchVariants() -> Variant.Search.UseCase {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Variant.Search.Scope(
                        query: Variant.Search.Query.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
