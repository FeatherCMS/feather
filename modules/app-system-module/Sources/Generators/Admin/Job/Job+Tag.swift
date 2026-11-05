import FeatherOpenAPI

extension Job {
    struct Tag: TagRepresentable {
        var name: String { "System jobs" }
    }
}
