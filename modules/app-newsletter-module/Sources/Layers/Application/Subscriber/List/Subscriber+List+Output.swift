public import FeatherApplication
public import NewsletterModule

extension Subscriber.List {
    public struct Output: DTO {
        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}
