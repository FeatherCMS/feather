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
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeRemoveTag() -> Tag.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Tag.Remove.Scope(
                    post: Post.Repository.Database(
                        context: context
                    ),
                    tag: Tag.Repository.Database(
                        context: context
                    ),
                    metadata: WebModule.Metadata.Repository.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
