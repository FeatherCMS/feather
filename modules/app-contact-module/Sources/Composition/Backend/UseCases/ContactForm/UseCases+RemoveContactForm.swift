public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import ContactModule

extension UseCases {

    public func makeRemoveContactForm() -> Form.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Form.Remove.Scope(
                    form: FormDatabaseRepository(context: context)
                )
            }
        )
        return Form.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
