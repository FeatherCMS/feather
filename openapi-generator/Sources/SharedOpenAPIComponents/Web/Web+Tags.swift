import FeatherOpenAPI

public struct WebContentTag: TagRepresentable {
    public var name: String { "Web" }
    public var description: String? { "Public app web endpoints" }

    public init() {}
}
