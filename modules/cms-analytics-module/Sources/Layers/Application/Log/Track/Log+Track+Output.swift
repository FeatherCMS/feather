import AnalyticsDomain
public import AnalyticsModule
public import FeatherApplication

extension Log.Track {
    public struct Output: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
