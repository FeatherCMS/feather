public import FeatherModuleKit
public import UserModule

extension Role.Event.Seed {
    public struct Provider: FeatherModuleKit.Event {
        public typealias Output = [Definition]

        public init() {}
    }
}
