import FeatherApplication
import FeatherContracts

public protocol WebMarkdownBlockRenderer: Sendable {
    var name: String { get }

    func render(
        identifier: String,
        requestPath: String
    ) async -> String?
}
