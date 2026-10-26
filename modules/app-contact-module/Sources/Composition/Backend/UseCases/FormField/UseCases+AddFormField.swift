public import ContactApplication
import ContactInfrastructure
public import ContactModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit

extension UseCases {
    public func makeAddFormField() -> FormField.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                FormField.Add.Scope(
                    field: FormField.Repository.Database(context: context)
                )
            }
        )
        return FormField.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
