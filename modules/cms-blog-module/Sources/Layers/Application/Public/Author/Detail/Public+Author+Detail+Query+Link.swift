import BlogModule

extension Public.Author.Detail.Query {
    public struct Link: Sendable {
        public let label: String
        public let url: String
        public let isBlank: Bool

        public init(label: String, url: String, isBlank: Bool) {
            self.label = label
            self.url = url
            self.isBlank = isBlank
        }
    }
}
