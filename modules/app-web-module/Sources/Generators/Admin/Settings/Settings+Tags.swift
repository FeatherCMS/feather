public import FeatherOpenAPI

extension Settings {
    public struct Tag: TagRepresentable {
        public var name: String = "Settings"
        public var description: String? = "Manage web settings."
    }
}
