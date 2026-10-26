public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure

extension UseCases {

    public func makeEditAuthorLink() -> AuthorLink.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                AuthorLink.Edit.Scope(
                    authorLink: AuthorLink.Repository.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
