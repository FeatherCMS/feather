public import FeatherModuleKit
public import UserModule

extension Role.Event.Seed {
    public struct Provider: FeatherModuleKit.Event<[Definition]> {
        public init() {}
    }
}
