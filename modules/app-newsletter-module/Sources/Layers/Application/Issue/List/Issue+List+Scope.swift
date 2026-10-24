public import FeatherModuleKit
public import NewsletterModule

extension Issue.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let issue: any Query.Interface

        public init(issue: any Query.Interface) {
            self.issue = issue
        }
    }
}
