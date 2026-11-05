public import struct Foundation.Date

extension Public.RSS {
    public struct Item: Sendable {
        public let title: String
        public let description: String
        public let url: String
        public let publicationDate: Date?

        public init(
            title: String,
            description: String,
            url: String,
            publicationDate: Date? = nil
        ) {
            self.title = title
            self.description = description
            self.url = url
            self.publicationDate = publicationDate
        }
    }
}
