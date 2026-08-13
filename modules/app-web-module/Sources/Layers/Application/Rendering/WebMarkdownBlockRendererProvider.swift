import FeatherApplication
import FeatherContracts

public struct WebMarkdownBlockRendererProvider: Event {
    public typealias Output = (any WebMarkdownBlockRenderer)?

    public let request: WebMarkdownBlockRendererRequest

    public init(request: WebMarkdownBlockRendererRequest) {
        self.request = request
    }
}
