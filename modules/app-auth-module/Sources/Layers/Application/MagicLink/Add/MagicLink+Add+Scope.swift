public import AuthDomain
public import AuthModule
public import FeatherModuleKit

extension MagicLink.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let magicLink: any MagicLink.Repository.Interface
        public init(magicLink: any MagicLink.Repository.Interface) {
            self.magicLink = magicLink
        }
    }
}
