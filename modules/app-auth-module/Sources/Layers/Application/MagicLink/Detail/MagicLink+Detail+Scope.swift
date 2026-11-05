public import AuthModule
public import FeatherModuleKit

extension MagicLink.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let magicLink: any Query.Interface
        public init(magicLink: any Query.Interface) {
            self.magicLink = magicLink
        }
    }
}
