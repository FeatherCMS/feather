public import FeatherModuleKit
public import SystemModule

extension Permission.Event {
    public struct Seed: FeatherModuleKit.Event<[Permission.Seed]> {
        public init() {}
    }
}
