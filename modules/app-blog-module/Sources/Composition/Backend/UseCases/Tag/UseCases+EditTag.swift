public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit
import MediaBackend
import SystemApplication
import SystemInfrastructure
import SystemModule
import WebDomain
import WebInfrastructure

extension UseCases {

    public func makeEditTag() -> Tag.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Tag.Edit.Scope(
                    tag: Tag.Repository.Database(
                        context: context
                    ),
                    metadata: Metadata.Repository.Database(
                        context: context
                    ),
                    variable: SystemModule.Variable.Lookup.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
