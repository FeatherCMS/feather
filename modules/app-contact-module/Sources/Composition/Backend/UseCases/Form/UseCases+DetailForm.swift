public import ContactApplication
import ContactInfrastructure
public import ContactModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit

extension UseCases {

    public func makeDetailForm() -> Form.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Form.Detail.Scope(
                    form: Form.Detail.Query.Database(context: context)
                )
            }
        )
        return Form.Detail.UseCase(
            authorizer: authorizer,
            query: query
        )
    }
}
