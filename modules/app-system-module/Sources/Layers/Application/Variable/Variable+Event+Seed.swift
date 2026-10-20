public import FeatherModuleKit
public import SystemModule

extension Variable.Event {
    public struct Seed: FeatherModuleKit.Event {
        public typealias Output = [Variable.Seed]

        public init() {}
    }
}
