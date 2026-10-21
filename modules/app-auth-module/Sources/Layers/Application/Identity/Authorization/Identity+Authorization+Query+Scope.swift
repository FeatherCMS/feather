public import FeatherModuleKit
public import UserModule

extension Identity.Authorization.Query {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorization: any Interface

        public init(authorization: any Interface) {
            self.authorization = authorization
        }
    }
}
