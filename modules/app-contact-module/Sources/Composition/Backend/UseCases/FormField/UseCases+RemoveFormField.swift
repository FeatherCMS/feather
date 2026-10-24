public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import ContactModule

extension UseCases {

    public func makeRemoveFormField() -> FormField.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                FormField.Remove.Scope(
                    field: FormField.Repository.Database(context: context)
                )
            }
        )
        return FormField.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
