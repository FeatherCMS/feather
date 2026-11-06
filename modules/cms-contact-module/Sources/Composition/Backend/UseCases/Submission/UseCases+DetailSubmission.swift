public import ContactApplication
import ContactInfrastructure
public import ContactModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit

extension UseCases {

    public func makeDetailSubmission() -> Submission.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Submission.Detail.Scope(
                    submission: Submission.Detail.Query.Database(
                        context: context
                    )
                )
            }
        )
        return Submission.Detail.UseCase(
            authorizer: authorizer,
            query: query
        )
    }
}
