import FeatherModuleKit
import NewsletterDomain
import NewsletterModule

extension Campaign.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let campaign: any Campaign.Repository.Interface

        public init(campaign: any Campaign.Repository.Interface) {
            self.campaign = campaign
        }
    }
}
