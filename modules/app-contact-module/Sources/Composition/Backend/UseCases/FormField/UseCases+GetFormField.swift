public import ContactApplication
import ContactInfrastructure
public import ContactModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit

extension UseCases {

    public func makeGetFormField() -> FormField.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                FormField.Detail.Scope(
                    field: FormField.Detail.Query.Database(context: context)
                )
            }
        )
        return FormField.Detail.UseCase(
            authorizer: authorizer,
            query: query
        )
    }
}
