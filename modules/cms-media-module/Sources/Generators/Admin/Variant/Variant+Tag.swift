import FeatherOpenAPI

extension Variant {
    struct Tag: TagRepresentable {
        var name: String = "MediaVariants"
        var description: String? =
            "Manage media variants and their processing rules."
    }
}
