import FeatherOpenAPI

extension Account {
    public struct Tag: TagRepresentable {
        public var name: String = "Account"
        public var description: String? = "Account endpoints."
        public init() {}
    }
}
