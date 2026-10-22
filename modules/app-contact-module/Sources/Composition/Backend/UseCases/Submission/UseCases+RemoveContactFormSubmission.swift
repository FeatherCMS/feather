public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import ContactModule

extension UseCases {

    public func makeRemoveContactFormSubmission() -> Submission.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Submission.Remove.Scope(
                    form: FormDatabaseRepository(context: context),
                    submission: SubmissionDatabaseRepository(context: context)
                )
            }
        )
        return Submission.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
