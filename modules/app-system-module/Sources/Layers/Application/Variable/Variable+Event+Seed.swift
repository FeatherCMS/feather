public import SystemModule
public import FeatherModuleKit

extension Variable.Event {
    public struct Seed: Event {
        public typealias Output = [Variable.Seed]

        public init() {}
    }
}
