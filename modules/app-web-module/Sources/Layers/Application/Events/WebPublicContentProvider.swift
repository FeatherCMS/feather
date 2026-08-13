import FeatherContracts

public struct WebPublicContentProvider: Event {
    public typealias Output = WebPublicContentResult?

    public let request: WebPublicContentEventContext

    public init(
        request: WebPublicContentEventContext
    ) {
        self.request = request
    }
}
