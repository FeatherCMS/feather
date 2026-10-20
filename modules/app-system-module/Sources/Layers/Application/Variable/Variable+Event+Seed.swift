public import SystemModule
public import FeatherModuleKit

extension Variable.Event {
    public struct Seed: FeatherModuleKit.Event {
        public typealias Output = [Variable.Seed]

        public init() {}
    }
}
