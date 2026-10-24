public import struct Foundation.Data

extension UseCases {
    public struct VariantAssetFile: Sendable {
        public let data: Data
        public let contentType: String
        public let filename: String

        public init(
            data: Data,
            contentType: String,
            filename: String
        ) {
            self.data = data
            self.contentType = contentType
            self.filename = filename
        }
    }
}
