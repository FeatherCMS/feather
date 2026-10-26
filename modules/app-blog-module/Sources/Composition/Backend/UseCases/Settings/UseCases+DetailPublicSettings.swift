public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure
import WebModule

extension UseCases {

    public func makeDetailPublicSettings() -> BlogModule.Settings.Public.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                BlogModule.Settings.Public.Detail.Scope(
                    settings: BlogModule.Settings.Public.Detail.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }
}
