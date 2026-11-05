public import FeatherModuleKit
public import NewsletterDomain
public import NewsletterModule

extension Issue.TestEmail {
    public struct Scope: FeatherModuleKit.Scope {
        public let newsletter: any Campaign.Repository.Interface

        public init(newsletter: any Campaign.Repository.Interface) {
            self.newsletter = newsletter
        }
    }
}
