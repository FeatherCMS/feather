public import FeatherApplication
public import WebDomain

public import struct Foundation.Date

extension Menu.Detail {
    public struct Output: DTO {
        public let id: String
        public let key: String
        public let name: String
        public let notes: String?
        public let createdAt: Date
        public let updatedAt: Date

        public init(
            id: String,
            key: String,
            name: String,
            notes: String?,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.notes = notes
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }

        init(detail: MenuDetail) {
            self.init(
                id: detail.id,
                key: detail.key,
                name: detail.name,
                notes: detail.notes,
                createdAt: detail.createdAt,
                updatedAt: detail.updatedAt
            )
        }
    }
}
