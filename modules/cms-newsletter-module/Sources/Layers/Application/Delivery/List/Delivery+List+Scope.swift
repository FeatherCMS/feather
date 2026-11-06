public import FeatherModuleKit
public import NewsletterModule

extension Delivery.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let delivery: any Query.Interface

        public init(delivery: any Query.Interface) {
            self.delivery = delivery
        }
    }
}
