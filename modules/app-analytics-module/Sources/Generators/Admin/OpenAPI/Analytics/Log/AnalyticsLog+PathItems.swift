import FeatherOpenAPI

struct AnalyticsLogListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AnalyticsLogListOperation() }
}

struct AnalyticsLogSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AnalyticsLogSearchOperation() }
}

struct AnalyticsLogIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AnalyticsLogGetOperation() }
}
