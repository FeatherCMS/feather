import Application
import BlogDomain

public struct ReadAuthor: Scope {
    public let author: any AuthorQueries

    public init(author: any AuthorQueries) {
        self.author = author
    }
}
