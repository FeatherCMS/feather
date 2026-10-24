public import FeatherApplication
public import NewsletterModule

extension Campaign.List {
    public struct Output: DTO {
        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}
