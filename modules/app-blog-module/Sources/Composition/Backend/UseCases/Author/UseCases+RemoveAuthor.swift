public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeRemoveAuthor() -> RemoveAuthor {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteAuthorPostsMetadata(
                    post: PostDatabaseRepository(
                        context: context
                    ),
                    author: AuthorDatabaseRepository(
                        context: context
                    ),
                    metadata: MetadataDatabaseRepository(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
