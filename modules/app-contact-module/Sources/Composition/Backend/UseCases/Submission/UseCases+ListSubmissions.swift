public import ContactApplication
import ContactInfrastructure
public import ContactModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit

extension UseCases {

    public func makeListSubmissions() -> Submission.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Submission.List.Scope(
                    submission: Submission.List.Query.Database(
                        context: context
                    )
                )
            }
        )
        return Submission.List.UseCase(
            authorizer: authorizer,
            query: query
        )
    }
}
