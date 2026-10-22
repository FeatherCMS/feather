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

extension UseCases {

    public func makeGetSettings() -> Settings.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Settings.Detail.Scope(
                    settings: Settings.Repository.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
