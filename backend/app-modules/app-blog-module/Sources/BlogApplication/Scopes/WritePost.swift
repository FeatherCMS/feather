import Application
import BlogDomain

public struct WritePost: Scope {
    public let post: any PostRepository

    public init(post: any PostRepository) {
        self.post = post
    }
}
