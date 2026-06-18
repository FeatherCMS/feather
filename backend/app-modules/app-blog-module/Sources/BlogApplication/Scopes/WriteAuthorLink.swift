import Application
import BlogDomain

public struct WriteAuthorLink: Scope {
    public let authorLink: any AuthorLinkRepository

    public init(authorLink: any AuthorLinkRepository) {
        self.authorLink = authorLink
    }
}
