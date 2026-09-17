import FeatherApplication
import FeatherContracts

public struct MediaVariantProcessorCreate: DTO {
    public let variantId: String
    public let name: String
    public let matchExtensions: String
    public let commandTemplate: String
    public let isActive: Bool

    public init(variantId: String, name: String, matchExtensions: String, commandTemplate: String, isActive: Bool) {
        self.variantId = variantId
        self.name = name
        self.matchExtensions = matchExtensions
        self.commandTemplate = commandTemplate
        self.isActive = isActive
    }
}
