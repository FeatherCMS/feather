public import FeatherDBAL
public import FeatherDatabase
public import FeatherDomain

/// Application-lifetime database dependencies shared by module composition.
public struct DatabaseClientContext: Sendable {
    public let database: any DatabaseClient
    public let idGenerator: any IDGenerator
    public let platform: any DatabasePlatform

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        platform: any DatabasePlatform
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.platform = platform
    }
}
