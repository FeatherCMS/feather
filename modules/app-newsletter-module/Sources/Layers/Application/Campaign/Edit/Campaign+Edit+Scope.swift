public import FeatherModuleKit
public import NewsletterDomain
public import NewsletterModule

extension Campaign.Edit {
    public struct Scope: FeatherModuleKit.Scope {
        public let campaign: any Campaign.Repository.Interface

        public init(campaign: any Campaign.Repository.Interface) {
            self.campaign = campaign
        }
    }
}
