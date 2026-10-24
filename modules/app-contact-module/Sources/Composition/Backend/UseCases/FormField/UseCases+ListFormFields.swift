public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import ContactModule

extension UseCases {

    public func makeListFormFields() -> FormField.List.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                FormField.List.Scope(
                    form: Form.Repository.Database(context: context),
                    field: FormField.Repository.Database(context: context)
                )
            }
        )
        return FormField.List.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
