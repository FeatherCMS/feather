public import FeatherModuleKit
public import NewsletterDomain
public import NewsletterModule

extension Issue.Schedule {
    public struct Scope: FeatherModuleKit.Scope {
        public let issue: any Issue.Repository.Interface

        public init(issue: any Issue.Repository.Interface) {
            self.issue = issue
        }
    }
}
