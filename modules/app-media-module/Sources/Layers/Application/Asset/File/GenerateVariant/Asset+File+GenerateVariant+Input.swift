public import FeatherApplication
public import MediaModule

extension Asset.File.GenerateVariant {
    public struct Input: DTO {
        public let assetId: String

        public init(assetId: String) {
            self.assetId = assetId
        }
    }
}
