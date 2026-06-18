import FeatherOpenAPI

public struct BlogContentTag: TagRepresentable {
    public var name: String { "Blog" }
    public var description: String? { "Public app blog endpoints" }

    public init() {}
}
