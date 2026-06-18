import FeatherOpenAPI

struct AnalyticsLogTrackPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AnalyticsLogTrackOperation() }
}
