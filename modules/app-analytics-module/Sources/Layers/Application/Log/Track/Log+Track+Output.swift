import AnalyticsDomain
public import FeatherApplication

extension Log {
    public enum Track {}
}

extension Log.Track {
    public struct Output: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
