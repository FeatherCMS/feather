public import FeatherDatabase
public import FeatherDomain

/// Application-lifetime database dependencies shared by module composition.
public struct DatabaseClientContext: Sendable {
    public let database: any DatabaseClient
    public let idGenerator: any IDGenerator

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator
    ) {
        self.database = database
        self.idGenerator = idGenerator
    }
}
