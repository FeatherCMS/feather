public import BlogModule
public import FeatherModuleKit

extension AuthorLink.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorLink: any Query.Interface

        public init(authorLink: any Query.Interface) {
            self.authorLink = authorLink
        }
    }
}
