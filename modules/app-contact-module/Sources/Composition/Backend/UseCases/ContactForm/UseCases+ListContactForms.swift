public import ContactApplication
import ContactInfrastructure
public import ContactModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit

extension UseCases {

    public func makeListContactForms() -> Form.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Form.List.Scope(
                    form: Form.List.Query.Database(context: context)
                )
            }
        )
        return Form.List.UseCase(
            authorizer: authorizer,
            query: query
        )
    }
}
