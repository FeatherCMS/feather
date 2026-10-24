import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherApplication
import FeatherInfrastructure

extension UseCases {
    func makeDetailAuthEmail() -> Email.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext
        ) { context in
            Email.Detail.Scope(
                email: Email.Detail.Query.Database(context: context)
            )
        }
        return .init(authorizer: authorizer, query: query)
    }

    func makeSearchAuthEmails() -> Email.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Email.Search.Scope(
                    authEmail: Email.Search.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeListAuthEmails() -> Email.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext
        ) { context in
            Email.List.Scope(
                authEmail: Email.List.Query.Database(context: context)
            )
        }
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeAddAuthEmail() -> Email.Add.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext
            ) { context in
                Email.Add.Scope(
                    authEmail: Email.Repository.Database(context: context)
                )
            }
        )
    }

    func makeEditAuthEmail() -> Email.Edit.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext
            ) { context in
                Email.Edit.Scope(
                    authEmail: Email.Repository.Database(context: context)
                )
            }
        )
    }

    func makeRemoveAuthEmails() -> Email.Remove.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext
            ) { context in
                Email.Remove.Scope(
                    authEmail: Email.Repository.Database(context: context)
                )
            }
        )
    }
}
