import Application
import BlogDomain

public struct ReadAuthorLink: Scope {
    public let authorLink: any AuthorLinkQueries

    public init(authorLink: any AuthorLinkQueries) {
        self.authorLink = authorLink
    }
}
