import ContactApplication
import ContactContracts
import ContactInfrastructure
public import FeatherApplication
public import FeatherContracts
public import FeatherInfrastructure

public struct UseCases: Sendable {
    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer
    let jobs: any SendMailJobController

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer,
        jobs: any SendMailJobController
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
        self.jobs = jobs
    }
}

extension UseCases {
    func formTransaction() -> DatabaseTransactionExecutor<
        WriteForm
    > {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteForm(
                    form: FormDatabaseRepository(context: context),
                    field: FormFieldDatabaseRepository(context: context),
                    mail: SubmissionMailDatabaseRepository(context: context),
                    submission: SubmissionDatabaseRepository(context: context)
                )
            }
        )
    }

}
