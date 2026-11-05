public import FeatherApplication
public import MediaModule

extension Variant.Processor.Detail {
    public struct Input: DTO {
        public let variantId: String
        public let id: String

        public init(variantId: String, id: String) {
            self.variantId = variantId
            self.id = id
        }
    }
}
