import Foundation
import Logging
import Markdown

struct MarkdownContentRenderer: ContentRenderer {
    private let logger: Logger

    init(
        logger: Logger = .init(label: "WebApp.Theme.MarkdownContentRenderer")
    ) {
        self.logger = logger
    }

    func render(
        markdown: String,
        requestPath: String
    ) -> String {
        guard !markdown.isEmpty else {
            return markdown
        }
        let output = HTMLFormatter.format(
            Document(parsing: markdown)
        )
        if output.isEmpty && !markdown.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            logger.warning(
                "Markdown rendering produced empty output.",
                metadata: [
                    "path": .string(requestPath)
                ]
            )
            return markdown
        }
        return output
    }
}
