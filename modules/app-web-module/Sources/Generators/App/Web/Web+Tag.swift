import FeatherOpenAPI

extension Web {
    struct Tag: TagRepresentable {
        var name: String { "Web" }
        var description: String? { "Public app web endpoints" }
    }
}
