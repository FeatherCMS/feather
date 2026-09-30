import FeatherOpenAPI

struct AnalyticsLogOverviewPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AnalyticsLogOverviewOperation() }
}
