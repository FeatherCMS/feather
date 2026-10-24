import FeatherApplication
import FeatherDatabase
import FeatherInfrastructure
import FeatherModuleKit
import FeatherStorage
import Foundation
import MediaApplication
import MediaDomain
import MediaInfrastructure
import MediaModule
import NIOCore

extension UseCases {
    func writeTransaction<Scope: FeatherModuleKit.Scope>(
        scope: @Sendable @escaping (DatabaseTransactionContext) -> Scope
    ) -> DatabaseTransactionExecutor<Scope> {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: scope
        )
    }
}
