public import FeatherDatabase

extension FeatherTesting.DatabaseClient {
    public struct Mock<Connection: FeatherDatabase.DatabaseConnection>:
        FeatherDatabase.DatabaseClient
    {
        public let connection: Connection

        public init(connection: Connection) {
            self.connection = connection
        }

        @discardableResult
        public func withConnection<T>(
            _ closure: (Connection) async throws -> T
        ) async throws(FeatherDatabase.DatabaseError) -> T {
            do {
                return try await closure(connection)
            }
            catch let error as FeatherDatabase.DatabaseError {
                throw error
            }
            catch {
                throw .connection(error)
            }
        }

        @discardableResult
        public func withTransaction<T>(
            _ closure: (Connection) async throws -> T
        ) async throws(FeatherDatabase.DatabaseError) -> T {
            do {
                return try await closure(connection)
            }
            catch let error as FeatherDatabase.DatabaseError {
                throw error
            }
            catch let error as any FeatherDatabase.DatabaseTransactionError {
                throw .transaction(error)
            }
            catch {
                throw .query(error)
            }
        }
    }
}
