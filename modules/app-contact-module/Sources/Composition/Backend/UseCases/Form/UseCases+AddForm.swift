public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import ContactModule

extension UseCases {
    public func makeAddForm() -> Form.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Form.Add.Scope(
                    form: Form.Repository.Database(context: context),
                    field: FormField.Repository.Database(context: context),
                    mail: SubmissionMail.Repository.Database(context: context)
                )
            }
        )
        return Form.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
