public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import ContactModule

extension UseCases {

    public func makeListFormFields() -> FormField.List.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                FormField.List.Scope(
                    form: FormDatabaseRepository(context: context),
                    field: FormFieldDatabaseRepository(context: context)
                )
            }
        )
        return FormField.List.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
