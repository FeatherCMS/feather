import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Analytics.Log {
    struct Tag: TagRepresentable {
        var name: String = "Analytics"
        var description: String = "Frontend analytics operations"
    }
}
