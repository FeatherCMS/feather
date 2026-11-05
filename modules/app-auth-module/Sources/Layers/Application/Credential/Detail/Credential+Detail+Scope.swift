public import AuthModule
public import FeatherModuleKit

extension Credential.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let credential: any Query.Interface

        public init(credential: any Query.Interface) {
            self.credential = credential
        }
    }
}
