import FeatherOpenAPI

extension Asset.File {
    struct Tag: TagRepresentable {
        var name: String = "MediaAssets"
        var description: String? = "Public media assets."
    }
}
