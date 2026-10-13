public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure

extension UseCases {

    public func makeEditAuthorLink() -> EditAuthorLink {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteAuthorLink(
                    authorLink: AuthorLinkDatabaseRepository(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
