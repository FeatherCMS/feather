import FeatherContracts
import FeatherDomain

public struct UserEventContext: ExecutionContext {
    public let idGenerator: any IDGenerator

    public init(idGenerator: any IDGenerator) {
        self.idGenerator = idGenerator
    }
}
