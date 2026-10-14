public import FeatherDatabase

public protocol DatabaseTable {
    static var name: String { get }

    var connection: any DatabaseConnection { get }
}
