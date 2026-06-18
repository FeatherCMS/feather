import FeatherOpenAPI

struct AnalyticsLogOverviewPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AnalyticsLogOverviewOperation() }
}
