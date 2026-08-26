import FeatherAdmin
import Foundation
import Mustache

public struct DefaultThemeRenderer: PublicThemeRenderer {

    private let library: MustacheLibrary
    private let templatePath: @Sendable (String) -> String?
    private let layoutTemplate = "html"

    public init(
        templateLoader: any TemplateLoader,
        templatePath: @escaping @Sendable (String) -> String?
    ) throws {
        self.library = .init(templates: try templateLoader.load())
        self.templatePath = templatePath
    }

    public func render(
        templateIdentifier: String?,
        context: [String: Any]
    ) -> HTMLResponse {
        let template =
            templatePath(templateIdentifier ?? "") ?? "pages/default"
        let body =
            library.render(
                context,
                withTemplate: template
            )
            ?? "<section><p>Theme render failed.</p></section>"
        var layoutContext = context
        layoutContext["body"] = body
        let html =
            library.render(layoutContext, withTemplate: layoutTemplate)
            ?? "<!DOCTYPE html><html lang=\"en-US\"><body><p>Theme render failed.</p></body></html>"
        return .init(content: html)
    }
}
