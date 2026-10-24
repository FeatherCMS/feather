import FeatherDatabase
public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makeDetailVariant() -> Variant.Detail.UseCase {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Variant.Detail.Scope(
                        query: Variant.Detail.Query.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
