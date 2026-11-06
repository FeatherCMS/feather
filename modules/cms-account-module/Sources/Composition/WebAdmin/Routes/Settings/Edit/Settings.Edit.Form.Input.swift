import AccountModule

extension Settings.Edit.Form {

    public struct Input: Codable, Sendable, Equatable,
        Hashable
    {
        public let language: String
        public let timezone: String
        public let pageSize: Int
    }
}
