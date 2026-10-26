public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import ContactModule

extension UseCases {
    public func makeEditSubmission() -> Submission.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Submission.Edit.Scope(
                    form: Form.Repository.Database(context: context),
                    submission: Submission.Repository.Database(context: context)
                )
            }
        )
        return Submission.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
