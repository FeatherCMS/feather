import Application
import BlogDomain

public struct WriteAuthor: Scope {
    public let author: any AuthorRepository

    public init(author: any AuthorRepository) {
        self.author = author
    }
}
