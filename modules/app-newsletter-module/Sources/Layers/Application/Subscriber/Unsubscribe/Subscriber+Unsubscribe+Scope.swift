public import FeatherModuleKit
public import NewsletterDomain
public import NewsletterModule

extension Subscriber.Unsubscribe {
    public struct Scope: FeatherModuleKit.Scope {
        public let subscriber: any Subscriber.Repository.Interface

        public init(
            subscriber: any Subscriber.Repository.Interface
        ) {
            self.subscriber = subscriber
        }
    }
}
