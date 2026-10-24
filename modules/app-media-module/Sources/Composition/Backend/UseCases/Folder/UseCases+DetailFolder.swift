import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit
public import MediaApplication
import MediaDomain
import MediaInfrastructure
public import MediaModule

extension UseCases {

    public func makeDetailFolder() -> Asset.Folder.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Asset.Folder.Detail.Scope(
                    query: Asset.Folder.Detail.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
