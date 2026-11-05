public import ContactApplication
import ContactInfrastructure
public import ContactModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit

extension UseCases {

    public func makeRemoveSubmission() -> Submission.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Submission.Remove.Scope(
                    form: Form.Repository.Database(context: context),
                    submission: Submission.Repository.Database(context: context)
                )
            }
        )
        return Submission.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
