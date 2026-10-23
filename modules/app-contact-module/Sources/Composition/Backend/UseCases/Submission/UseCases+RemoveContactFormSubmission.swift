public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import ContactModule

extension UseCases {

    public func makeRemoveContactFormSubmission() -> Submission.Remove.UseCase {
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
