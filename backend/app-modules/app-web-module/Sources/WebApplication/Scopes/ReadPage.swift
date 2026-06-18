import Application
import WebDomain

public struct ReadPage: Scope {
    public let page: any PageQueries

    public init(page: any PageQueries) {
        self.page = page
    }
}
