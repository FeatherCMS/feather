import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct NewsContentTag: TagRepresentable {
    public var name: String = "News"
    public var description: String? = "News public content"

    public init() {}
}
