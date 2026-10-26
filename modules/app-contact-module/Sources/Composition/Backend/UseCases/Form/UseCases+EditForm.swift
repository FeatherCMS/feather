public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import ContactModule

extension UseCases {
    public func makeEditForm() -> Form.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Form.Edit.Scope(
                    form: Form.Repository.Database(context: context),
                    field: FormField.Repository.Database(context: context),
                    mail: SubmissionMail.Repository.Database(context: context)
                )
            }
        )
        return Form.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
