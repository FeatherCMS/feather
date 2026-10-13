import FeatherOpenAPI

struct AnalyticsLogListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AnalyticsLogListOperation() }
}

struct AnalyticsLogSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AnalyticsLogSearchOperation() }
}

struct AnalyticsLogIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AnalyticsLogGetOperation() }
}
