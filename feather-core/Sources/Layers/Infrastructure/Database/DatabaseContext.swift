import FeatherDatabase

public protocol DatabaseContext: Sendable {
    var connection: any DatabaseConnection { get }
}
