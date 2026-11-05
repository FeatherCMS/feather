public import ContactApplication
import ContactInfrastructure
public import ContactModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit

extension UseCases {

    public func makeSubmitForm() -> Form.Submit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Form.Submit.Scope(
                    form: Form.Repository.Database(context: context),
                    field: FormField.Repository.Database(context: context),
                    mail: SubmissionMail.Repository.Database(context: context),
                    submission: Submission.Repository.Database(context: context)
                )
            }
        )
        return Form.Submit.UseCase(
            transaction: transaction,
            jobs: jobs,
            events: events
        )
    }
}
