extension Public {
    public struct Media: Sendable {
        public let assetId: String
        public let originalURL: String
        public let defaultURL: String
        public let variants: [Variant]

        public struct Variant: Sendable {
            public let key: String
            public let url: String

            public init(key: String, url: String) {
                self.key = key
                self.url = url
            }
        }

        public init(
            assetId: String,
            originalURL: String,
            defaultURL: String,
            variants: [Variant]
        ) {
            self.assetId = assetId
            self.originalURL = originalURL
            self.defaultURL = defaultURL
            self.variants = variants
        }
    }
}
