public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit
import MediaBackend
import SystemInfrastructure
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeGetSettings() -> BlogModule.Settings.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                BlogModule.Settings.Detail.Scope(
                    settings: BlogModule.Settings.Repository.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
