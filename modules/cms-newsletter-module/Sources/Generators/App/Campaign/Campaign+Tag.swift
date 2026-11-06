import FeatherOpenAPI

extension Campaign {
    struct Tag: TagRepresentable {
        var name: String = "Newsletter"
        var description: String? = "Public newsletter endpoints."
    }
}
