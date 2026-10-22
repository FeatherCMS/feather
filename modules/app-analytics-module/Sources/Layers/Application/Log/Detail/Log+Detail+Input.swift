public import AnalyticsDomain
public import FeatherApplication

extension Log.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
