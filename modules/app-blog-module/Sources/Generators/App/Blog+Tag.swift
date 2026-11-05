import FeatherOpenAPI

extension Blog {
    public struct Tag: TagRepresentable {
        public var name: String { "Blog" }
        public var description: String? { "Public app blog endpoints" }
        public init() {}
    }
}
