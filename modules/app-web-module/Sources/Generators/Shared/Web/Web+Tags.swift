public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct ContentTag: TagRepresentable {
    public var name: String { "Web" }
    public var description: String? { "Public app web endpoints" }

    public init() {}
}
