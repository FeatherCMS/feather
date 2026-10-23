public import FeatherApplication
public import NewsletterModule

extension Subscriber.List {
    public struct Output: DTO {
        public let items: [Subscriber.List.Item]

        public init(items: [Subscriber.List.Item]) {
            self.items = items
        }
    }
}
