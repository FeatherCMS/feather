public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeEditPost() -> Post.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Post.Edit.Scope(
                    post: Post.Repository.Database(
                        context: context
                    ),
                    metadata: WebModule.Metadata.Repository.Database(
                        context: context
                    ),
                    variable: SystemModule.Variable.Lookup.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
