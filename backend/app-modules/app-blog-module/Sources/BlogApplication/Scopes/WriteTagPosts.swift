import Application
import BlogDomain

public struct WriteTagPosts: Scope {
    public let tag: any TagRepository
    public let post: any PostRepository

    public init(
        tag: any TagRepository,
        post: any PostRepository
    ) {
        self.tag = tag
        self.post = post
    }
}
