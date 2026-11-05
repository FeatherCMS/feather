public import FeatherDBAL
public import FeatherDomain

public protocol DatabaseContext: DatabaseAccessContext {
    var idGenerator: any IDGenerator { get }
}
