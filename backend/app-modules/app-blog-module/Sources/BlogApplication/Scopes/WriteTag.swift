import Application
import BlogDomain

public struct WriteTag: Scope {
    public let tag: any TagRepository

    public init(tag: any TagRepository) {
        self.tag = tag
    }
}
