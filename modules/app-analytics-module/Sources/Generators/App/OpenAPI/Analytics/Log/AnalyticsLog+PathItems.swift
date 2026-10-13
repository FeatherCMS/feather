import FeatherOpenAPI

struct AnalyticsLogTrackPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AnalyticsLogTrackOperation() }
}
