import SystemModule
public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeAddPost() -> AddPost {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WritePostMetadata(
                    post: PostDatabaseRepository(
                        context: context
                    ),
                    metadata: MetadataDatabaseRepository(
                        context: context
                    ),
                    variable: SystemModule.Variable.Lookup.Database(
                        context: context
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
