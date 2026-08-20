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

    func makeResolveWebRoute() -> ResolveWebRoute {
            let query = DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    ReadMetadata(
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    )
                }
            )
            return .init(query: query)
        }
}

