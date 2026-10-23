public import ContactApplication
import ContactInfrastructure
public import ContactModule
import FeatherApplication
import FeatherInfrastructure

extension UseCases {
    public func makeSearchContactForms() -> Form.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Form.Search.Scope(
                    form: Form.Search.Query.Database(context: context)
                )
            }
        )
        return Form.Search.UseCase(authorizer: authorizer, query: query)
    }
}
