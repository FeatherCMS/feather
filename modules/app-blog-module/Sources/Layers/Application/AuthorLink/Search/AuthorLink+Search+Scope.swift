public import BlogModule
public import FeatherModuleKit

extension AuthorLink.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorLink: any Query.Interface

        public init(authorLink: any Query.Interface) {
            self.authorLink = authorLink
        }
    }
}
