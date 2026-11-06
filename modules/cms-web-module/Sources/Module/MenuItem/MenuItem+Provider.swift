public import FeatherModuleKit

extension MenuItem {
    public struct Provider: FeatherModuleKit.Event<[Definition]> {
        public let menuKey: String

        public init(menuKey: String) {
            self.menuKey = menuKey
        }
    }
}
