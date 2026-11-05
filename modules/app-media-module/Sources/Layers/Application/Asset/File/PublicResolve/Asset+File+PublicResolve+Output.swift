public import FeatherApplication
public import MediaModule

extension Asset.File.PublicResolve {
    public struct Output: DTO {
        public struct Variant: Sendable {
            public let key: String
            public let url: String

            public init(key: String, url: String) {
                self.key = key
                self.url = url
            }
        }

        public struct Item: Sendable {
            public let id: String
            public let url: String
            public let variants: [Variant]

            public init(id: String, url: String, variants: [Variant]) {
                self.id = id
                self.url = url
                self.variants = variants
            }
        }

        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}
