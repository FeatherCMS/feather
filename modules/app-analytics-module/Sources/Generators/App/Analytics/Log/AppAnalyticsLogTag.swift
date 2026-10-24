import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct AppAnalyticsLogTag: TagRepresentable {
    var name: String = "Analytics"
    var description: String = "Frontend analytics operations"
}
