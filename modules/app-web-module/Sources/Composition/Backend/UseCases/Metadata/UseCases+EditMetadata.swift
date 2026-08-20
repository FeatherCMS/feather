import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import Foundation
import SystemInfrastructure
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebInfrastructure

extension UseCases {

    func makeEditMetadata() -> EditMetadata {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMetadata(
                    metadata: MetadataDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
