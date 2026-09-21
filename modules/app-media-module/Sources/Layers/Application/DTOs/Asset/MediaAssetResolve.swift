import FeatherApplication
import FeatherContracts

public struct MediaAssetResolve: DTO {
    public struct Variant: Sendable {
        public let id: String
        public let key: String
        public let name: String
        public let url: String
        public let `extension`: String
        public init(
            id: String,
            key: String,
            name: String,
            url: String,
            `extension`: String
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.url = url
            self.extension = `extension`
        }
    }
    public struct Item: Sendable {
        public let id: String
        public let url: String
        public let `extension`: String
        public let title: String?
        public let altText: String?
        public let variants: [Variant]
        public init(
            id: String,
            url: String,
            `extension`: String,
            title: String?,
            altText: String?,
            variants: [Variant]
        ) {
            self.id = id
            self.url = url
            self.extension = `extension`
            self.title = title
            self.altText = altText
            self.variants = variants
        }
    }
    public let items: [Item]
    public init(items: [Item]) { self.items = items }
}
