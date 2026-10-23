public import struct Foundation.Data

extension UseCases {
    public struct OriginalAssetFile: Sendable {
        public let data: Data
        public let contentType: String
        public let filename: String
        public let slugPath: String

        public init(
            data: Data,
            contentType: String,
            filename: String,
            slugPath: String
        ) {
            self.data = data
            self.contentType = contentType
            self.filename = filename
            self.slugPath = slugPath
        }
    }
}
