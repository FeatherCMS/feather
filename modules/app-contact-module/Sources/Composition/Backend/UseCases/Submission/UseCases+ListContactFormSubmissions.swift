public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import ContactModule

extension UseCases {

    public func makeListContactFormSubmissions() -> Submission.List.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Submission.List.Scope(
                    form: Form.Repository.Database(context: context),
                    submission: Submission.Repository.Database(context: context)
                )
            }
        )
        return Submission.List.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
