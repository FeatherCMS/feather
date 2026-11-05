public import FeatherModuleKit
public import UserModule

extension Identity.Event.Seed {
    public struct Provider: FeatherModuleKit.Event<[Definition]> {
        public init() {}
    }
}
