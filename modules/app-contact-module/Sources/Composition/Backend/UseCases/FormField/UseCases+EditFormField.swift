public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import ContactModule

extension UseCases {
    public func makeEditFormField() -> FormField.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                FormField.Edit.Scope(
                    field: FormField.Repository.Database(context: context)
                )
            }
        )
        return FormField.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
