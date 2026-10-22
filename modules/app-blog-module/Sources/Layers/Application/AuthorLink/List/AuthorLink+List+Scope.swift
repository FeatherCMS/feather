public import BlogModule
public import FeatherModuleKit

extension AuthorLink.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorLink: any AuthorLink.List.Query.Interface

        public init(authorLink: any AuthorLink.List.Query.Interface) {
            self.authorLink = authorLink
        }
    }
}
