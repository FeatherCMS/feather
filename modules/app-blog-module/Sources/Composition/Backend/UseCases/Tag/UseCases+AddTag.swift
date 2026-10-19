import SystemModule
public import BlogApplication
import BlogInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaBackend
import SystemApplication
import SystemInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeAddTag() -> AddTag {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteTagMetadata(
                    tag: TagDatabaseRepository(
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
