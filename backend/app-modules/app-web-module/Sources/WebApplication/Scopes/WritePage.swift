import Application
import WebDomain

public struct WritePage: Scope {
    public let page: any PageRepository

    public init(page: any PageRepository) {
        self.page = page
    }
}
