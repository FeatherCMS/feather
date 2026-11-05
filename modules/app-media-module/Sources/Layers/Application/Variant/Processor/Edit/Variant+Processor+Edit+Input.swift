public import FeatherApplication
public import FeatherDomain
public import MediaModule

extension Variant.Processor.Edit {
    public struct Input: DTO {
        public let variantId: String
        public let id: String
        public let name: FieldChange<String>
        public let matchExtensions: FieldChange<String>
        public let commandTemplate: FieldChange<String>
        public let isActive: FieldChange<Bool>
        public init(
            variantId: String,
            id: String,
            name: FieldChange<String> = .unchanged,
            matchExtensions: FieldChange<String> = .unchanged,
            commandTemplate: FieldChange<String> = .unchanged,
            isActive: FieldChange<Bool> = .unchanged
        ) {
            self.variantId = variantId
            self.id = id
            self.name = name
            self.matchExtensions = matchExtensions
            self.commandTemplate = commandTemplate
            self.isActive = isActive
        }
    }
}
