public import FeatherModuleKit
public import UserModule

extension Identity.Event.Seed {
    public struct Provider: FeatherModuleKit.Event {
        public typealias Output = [Definition]

        public init() {}
    }
}
