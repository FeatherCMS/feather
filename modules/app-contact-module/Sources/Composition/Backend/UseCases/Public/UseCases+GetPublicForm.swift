public import ContactApplication
import ContactInfrastructure
public import ContactModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit

extension UseCases {

    public func makeGetPublicForm() -> Form.Public.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Form.Public.Detail.Scope(
                    form: Form.Public.Detail.Query.Database(context: context)
                )
            }
        )
        return Form.Public.Detail.UseCase(query: query)
    }
}
