public import ContactApplication
import ContactInfrastructure
public import ContactModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit

extension UseCases {

    public func makeListFormFields() -> FormField.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                FormField.List.Scope(
                    formField: FormField.List.Query.Database(context: context)
                )
            }
        )
        return FormField.List.UseCase(
            authorizer: authorizer,
            query: query
        )
    }
}
