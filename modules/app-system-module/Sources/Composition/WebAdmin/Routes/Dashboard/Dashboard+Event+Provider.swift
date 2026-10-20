public import FeatherModuleKit

extension Dashboard.Event {
    public struct Provider: FeatherModuleKit.Event {
        public typealias Output = [Definition]

        public init() {}
    }
}
