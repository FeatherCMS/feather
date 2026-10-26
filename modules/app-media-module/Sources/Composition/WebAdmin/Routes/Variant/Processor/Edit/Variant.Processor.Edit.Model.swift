import MediaModule

extension Variant.Processor.Edit {
    struct Model: Sendable {
        let id: String
        let variantId: String
        let name: String
        let matchExtensions: String
        let commandTemplate: String
        let isActive: Bool
    }
}
