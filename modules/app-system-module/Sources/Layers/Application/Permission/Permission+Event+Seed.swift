public import SystemModule
public import FeatherModuleKit

extension Permission.Event {
    public struct Seed: FeatherModuleKit.Event {
        public typealias Output = [Permission.Seed]

        public init() {}
    }
}
