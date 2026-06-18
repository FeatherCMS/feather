import Application
import BlogDomain

public struct ReadTag: Scope {
    public let tag: any TagQueries

    public init(tag: any TagQueries) {
        self.tag = tag
    }
}
