import FeatherModuleKit
import NewsletterDomain
import NewsletterModule

extension Issue.Remove {
    public struct Scope: FeatherModuleKit.Scope {
        public let newsletter: any Campaign.Repository.Interface
        public let issue: any Issue.Repository.Interface
        public let delivery: any Delivery.Repository.Interface

        public init(
            newsletter: any Campaign.Repository.Interface,
            issue: any Issue.Repository.Interface,
            delivery: any Delivery.Repository.Interface
        ) {
            self.newsletter = newsletter
            self.issue = issue
            self.delivery = delivery
        }
    }
}
