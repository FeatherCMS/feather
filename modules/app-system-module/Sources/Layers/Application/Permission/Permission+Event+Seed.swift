public import FeatherModuleKit
public import SystemModule

extension Permission.Event {
    public struct Seed: FeatherModuleKit.Event {
        public typealias Output = [Permission.Seed]

        public init() {}
    }
}
