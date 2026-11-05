public import BlogDomain
public import BlogModule
public import FeatherModuleKit

extension AuthorLink.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorLink: any AuthorLink.Repository.Interface

        public init(authorLink: any AuthorLink.Repository.Interface) {
            self.authorLink = authorLink
        }
    }
}
