public import BlogModule
public import FeatherModuleKit

extension AuthorLink.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorLink: any AuthorLink.Detail.Query.Interface

        public init(authorLink: any AuthorLink.Detail.Query.Interface) {
            self.authorLink = authorLink
        }
    }
}
