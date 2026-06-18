import Application
import BlogDomain

public struct ReadPost: Scope {
    public let post: any PostQueries

    public init(post: any PostQueries) {
        self.post = post
    }
}
