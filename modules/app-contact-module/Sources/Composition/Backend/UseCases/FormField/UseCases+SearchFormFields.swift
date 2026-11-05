public import ContactApplication
import ContactInfrastructure
public import ContactModule
import FeatherApplication
import FeatherInfrastructure

extension UseCases {
    public func makeSearchFormFields() -> FormField.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                FormField.Search.Scope(
                    formField: FormField.Search.Query.Database(context: context)
                )
            }
        )
        return FormField.Search.UseCase(authorizer: authorizer, query: query)
    }
}
