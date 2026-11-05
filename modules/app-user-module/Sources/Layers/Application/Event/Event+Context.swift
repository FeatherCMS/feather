public import FeatherDomain
public import FeatherModuleKit
public import UserModule

extension UserModule.Event {
    public struct Context: ExecutionContext {
        public let idGenerator: any IDGenerator

        public init(idGenerator: any IDGenerator) {
            self.idGenerator = idGenerator
        }
    }
}
