public import FeatherModuleKit
public import NewsletterModule

extension Subscriber.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let subscriber: any Query.Interface

        public init(subscriber: any Query.Interface) {
            self.subscriber = subscriber
        }
    }
}
