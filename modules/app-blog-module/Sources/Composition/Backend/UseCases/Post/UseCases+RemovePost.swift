public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure
import WebDomain
import WebInfrastructure

extension UseCases {

    public func makeRemovePost() -> Post.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Post.Remove.Scope(
                    post: Post.Repository.Database(
                        context: context
                    ),
                    metadata: Metadata.Repository.Database(
                        context: context
                    ),
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
