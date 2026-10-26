public import FeatherApplication
public import MediaModule

extension Variant.Processor.Remove {
    public struct Input: DTO {
        public let variantId: String
        public let ids: [String]
        public init(variantId: String, ids: [String]) {
            self.variantId = variantId
            self.ids = ids
        }
    }
}
