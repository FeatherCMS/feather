public import FeatherModuleKit

extension Public.RSS.Event {
    public struct Provider: FeatherModuleKit.Event<[Public.RSS.Item]> {
        public init() {}
    }
}
