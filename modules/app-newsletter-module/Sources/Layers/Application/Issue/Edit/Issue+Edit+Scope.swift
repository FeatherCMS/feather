import FeatherModuleKit
import NewsletterDomain
import NewsletterModule

extension Issue.Edit {
    public struct Scope: FeatherModuleKit.Scope {
        public let newsletter: any Campaign.Repository.Interface
        public let issue: any Issue.Repository.Interface

        public init(
            newsletter: any Campaign.Repository.Interface,
            issue: any Issue.Repository.Interface
        ) {
            self.newsletter = newsletter
            self.issue = issue
        }
    }
}
