public import BlogApplication
import BlogInfrastructure
public import BlogModule
public import FeatherInfrastructure
import WebModule

extension UseCases {

    public func makeGetPublicSettings() -> DatabaseQueryExecutor<
        BlogModule.Settings.Detail.Scope
    > {
        DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                BlogModule.Settings.Detail.Scope(
                    settings: BlogModule.Settings.Detail.Query.Database(
                        context: context
                    )
                )
            }
        )
    }
}
