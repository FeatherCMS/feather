public import FeatherApplication
public import MediaModule

public import struct Foundation.Date

extension Variant.Processor.Edit {
    public struct Output: DTO {
        public let id: String
        public let variantId: String
        public let name: String
        public let matchExtensions: String
        public let commandTemplate: String
        public let isActive: Bool
        public let createdAt: Date
        public let updatedAt: Date

        public init(
            id: String,
            variantId: String,
            name: String,
            matchExtensions: String,
            commandTemplate: String,
            isActive: Bool,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.variantId = variantId
            self.name = name
            self.matchExtensions = matchExtensions
            self.commandTemplate = commandTemplate
            self.isActive = isActive
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
