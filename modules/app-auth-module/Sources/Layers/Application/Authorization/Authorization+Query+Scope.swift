public import AuthModule
public import FeatherModuleKit

extension AuthModule.Authorization.Query {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorization: any Interface

        public init(authorization: any Interface) {
            self.authorization = authorization
        }
    }
}
