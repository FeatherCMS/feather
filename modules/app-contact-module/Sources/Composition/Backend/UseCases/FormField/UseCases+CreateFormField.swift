public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import ContactModule

extension UseCases {

    public func makeCreateFormField() -> FormField.Add.UseCase {
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
