public import FeatherDomain
public import MediaModule

public import struct Foundation.Date

extension Variant.Processor {
    public struct Model: FeatherDomain.Model {
        public struct New: Sendable {
            public let variantId: String
            public let name: String
            public let matchExtensions: String
            public let commandTemplate: String
            public let isActive: Bool
        }

        public let id: String
        public let variantId: String
        public var name: String
        public var matchExtensions: String
        public var commandTemplate: String
        public var isActive: Bool
        public let createdAt: Date
        public let updatedAt: Date

        package init(
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

        public static func create(
            variantId: String,
            name: String,
            matchExtensions: String,
            commandTemplate: String,
            isActive: Bool
        ) -> New {
            .init(
                variantId: variantId,
                name: name,
                matchExtensions: matchExtensions,
                commandTemplate: commandTemplate,
                isActive: isActive
            )
        }
    }
}

extension Variant.Processor.Model {
    public mutating func update(
        name: FieldChange<String> = .unchanged,
        matchExtensions: FieldChange<String> = .unchanged,
        commandTemplate: FieldChange<String> = .unchanged,
        isActive: FieldChange<Bool> = .unchanged
    ) {
        self.name = name.apply(to: self.name)
        self.matchExtensions = matchExtensions.apply(to: self.matchExtensions)
        self.commandTemplate = commandTemplate.apply(to: self.commandTemplate)
        self.isActive = isActive.apply(to: self.isActive)
    }
}
