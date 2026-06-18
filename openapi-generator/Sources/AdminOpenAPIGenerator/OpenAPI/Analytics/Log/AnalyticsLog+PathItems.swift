import FeatherOpenAPI

struct AnalyticsLogFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AnalyticsLogFiltersOperation() }
}

struct AnalyticsLogSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AnalyticsLogSearchOperation() }
}

struct AnalyticsLogIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AnalyticsLogGetOperation() }
}
