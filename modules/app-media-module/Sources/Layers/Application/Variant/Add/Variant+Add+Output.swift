public import FeatherApplication
public import MediaModule

public import struct Foundation.Date

extension Variant.Add {
    public struct Output: DTO {
        public struct Processor: Sendable {
            public let id: String
            public let variantId: String
            public let name: String
            public let matchExtensions: String
            public let commandTemplate: String
            public let isActive: Bool

            public init(
                id: String,
                variantId: String,
                name: String,
                matchExtensions: String,
                commandTemplate: String,
                isActive: Bool
            ) {
                self.id = id
                self.variantId = variantId
                self.name = name
                self.matchExtensions = matchExtensions
                self.commandTemplate = commandTemplate
                self.isActive = isActive
            }
        }

        public let id: String
        public let key: String
        public let name: String
        public let isRequired: Bool
        public let isActive: Bool
        public let processors: [Processor]
        public let createdAt: Date
        public let updatedAt: Date

        public init(
            id: String,
            key: String,
            name: String,
            isRequired: Bool,
            isActive: Bool,
            processors: [Processor],
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.isRequired = isRequired
            self.isActive = isActive
            self.processors = processors
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
