public import AccountModule
public import FeatherApplication

extension Settings.Edit {
    public struct Input: DTO {
        public let language: String
        public let timezone: String
        public let pageSize: Int
        public let userId: String?

        public init(
            language: String,
            timezone: String,
            pageSize: Int,
            userId: String? = nil
        ) {
            self.language = language
            self.timezone = timezone
            self.pageSize = pageSize
            self.userId = userId
        }
    }
}
