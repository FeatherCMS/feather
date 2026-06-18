import Application
import BlogDomain

public struct WriteAuthorPosts: Scope {
    public let author: any AuthorRepository
    public let post: any PostRepository

    public init(
        author: any AuthorRepository,
        post: any PostRepository
    ) {
        self.author = author
        self.post = post
    }
}
