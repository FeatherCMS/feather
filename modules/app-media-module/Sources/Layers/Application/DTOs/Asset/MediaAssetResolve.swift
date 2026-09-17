import FeatherApplication
import FeatherContracts

public struct MediaAssetResolve: DTO {
    public struct Variant: Sendable {
        public let name: String
        public let storageKey: String

        public init(
            name: String,
            storageKey: String
        ) {
            self.name = name
            self.storageKey = storageKey
        }
    }

    public struct Item: Sendable {
        public let id: String
        public let storageKey: String
        public let type: String
        public let title: String?
        public let altText: String?
        public let variants: [Variant]

        public init(
            id: String,
            storageKey: String,
            type: String,
            title: String?,
            altText: String?,
            variants: [Variant]
        ) {
            self.id = id
            self.storageKey = storageKey
            self.type = type
            self.title = title
            self.altText = altText
            self.variants = variants
        }
    }

    public let items: [Item]

    public init(items: [Item]) {
        self.items = items
    }
}
