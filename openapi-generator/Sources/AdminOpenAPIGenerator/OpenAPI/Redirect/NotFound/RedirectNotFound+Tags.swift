import FeatherOpenAPI

struct RedirectNotFoundTag: TagRepresentable {
    var name: String = "RedirectNotFound"
    var description: String? = "Review missing routes and 404 traffic."
}
