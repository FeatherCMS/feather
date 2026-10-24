public import FeatherModuleKit
public import NewsletterModule

extension Campaign.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let campaign: any Campaign.List.Query.Interface

        public init(campaign: any Campaign.List.Query.Interface) {
            self.campaign = campaign
        }
    }
}
