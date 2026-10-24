import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct ContentTag: TagRepresentable {
    var name: String { "Web" }
    var description: String? { "Public app web endpoints" }

    init() {}
}
