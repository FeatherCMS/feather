public import BlogModule
public import FeatherModuleKit

extension AuthorLink.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorLink: any AuthorLink.Query.Interface

        public init(authorLink: any AuthorLink.Query.Interface) {
            self.authorLink = authorLink
        }
    }
}
