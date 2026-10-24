public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import ContactModule

extension UseCases {

    public func makeGetFormField() -> FormField.Detail.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                FormField.Detail.Scope(
                    field: FormField.Repository.Database(context: context)
                )
            }
        )
        return FormField.Detail.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
