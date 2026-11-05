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

    public func makeListFolders() -> Asset.Folder.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Asset.Folder.List.Scope(
                    query: Asset.Folder.List.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
