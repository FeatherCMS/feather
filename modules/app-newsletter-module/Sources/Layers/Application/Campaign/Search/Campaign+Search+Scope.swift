public import FeatherModuleKit
public import NewsletterModule

extension Campaign.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let campaign: any Query.Interface

        public init(campaign: any Query.Interface) {
            self.campaign = campaign
        }
    }
}
