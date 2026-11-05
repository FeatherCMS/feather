public import FeatherApplication
public import MediaModule

extension Asset.File.PublicResolve {
    public struct Input: DTO {
        public let ids: [String]
        public let variants: [String]?

        public init(
            ids: [String],
            variants: [String]?
        ) {
            self.ids = ids
            self.variants = variants
        }
    }
}
