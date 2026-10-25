public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import ContactModule

extension UseCases {

    public func makeRemoveForm() -> Form.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Form.Remove.Scope(
                    form: Form.Repository.Database(context: context)
                )
            }
        )
        return Form.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
