import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure

extension UseCases {

    public func makeRemoveAuthorLink() -> RemoveAuthorLink {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteAuthorLink(
                    authorLink: AuthorLinkDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: idGenerator
                        )
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
