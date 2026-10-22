public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import ContactModule

extension UseCases {

    public func makeCreateContactForm() -> Form.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Form.Add.Scope(
                    form: FormDatabaseRepository(context: context),
                    field: FormFieldDatabaseRepository(context: context),
                    mail: SubmissionMailDatabaseRepository(context: context)
                )
            }
        )
        return Form.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
