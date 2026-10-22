public import AccountModule
public import FeatherModuleKit

extension AccountModule.Event.Seed {
    public struct Provider: FeatherModuleKit.Event {
        public typealias Output = [Definition]

        public init() {}
    }
}
