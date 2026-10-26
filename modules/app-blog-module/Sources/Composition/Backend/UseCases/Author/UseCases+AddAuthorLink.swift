public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure

extension UseCases {

    public func makeAddAuthorLink() -> AuthorLink.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                AuthorLink.Add.Scope(
                    authorLink: AuthorLink.Repository.Database(
                        context: context
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
