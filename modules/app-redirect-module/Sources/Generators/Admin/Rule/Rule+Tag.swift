import FeatherOpenAPI

extension Rule {
    struct Tag: TagRepresentable {
        var name: String = "RedirectRules"
        var description: String? = "Manage redirect rules."
    }
}
