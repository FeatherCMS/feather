import FeatherDatabase
import FeatherDatabasePostgres
import Foundation
import Logging
import PostgresNIO
import ServiceLifecycle
import Environment
import Foundation

public struct TestDatabaseBuilder {

    private let client: TestDatabaseClient

    public init(
        client: TestDatabaseClient
    ) {
        self.client = client
    }

    func buildTestDatabase(
        named name: String
    ) async throws {
        try await client.execute { database in
            try await database.withConnection { connection in
                let db = PostgresDatabase(connection: connection)
                try await db.drop(name: name)
                try await db.create(name: name)
            }
        }
    }
}
