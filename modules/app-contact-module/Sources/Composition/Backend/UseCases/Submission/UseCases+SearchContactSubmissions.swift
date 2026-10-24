public import ContactApplication
import ContactInfrastructure
public import ContactModule
import FeatherApplication
import FeatherInfrastructure

extension UseCases {
    public func makeSearchContactSubmissions() -> Submission.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Submission.Search.Scope(
                    submission: Submission.Search.Query.Database(context: context)
                )
            }
        )
        return Submission.Search.UseCase(authorizer: authorizer, query: query)
    }
}
