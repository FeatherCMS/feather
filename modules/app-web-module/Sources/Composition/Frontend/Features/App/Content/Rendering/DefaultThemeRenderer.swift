public import FeatherAdmin
import Mustache

public struct DefaultThemeRenderer: PublicThemeRenderer {

    private let fallbackLibrary: MustacheLibrary
    private let templateLoader: any TemplateLoader
    private let templatePath: @Sendable (String) -> String?
    private let layoutTemplate = "html"

    public init(
        templateLoader: any TemplateLoader,
        templatePath: @escaping @Sendable (String) -> String?
    ) throws {
        self.fallbackLibrary = .init(templates: try templateLoader.load())
        self.templateLoader = templateLoader
        self.templatePath = templatePath
    }

    public func render(
        templateIdentifier: String?,
        context: [String: any Sendable]
    ) -> HTMLResponse {
        #if DEBUG
        let library: MustacheLibrary
        if let templates = try? templateLoader.load() {
            library = .init(templates: templates)
        }
        else {
            library = fallbackLibrary
        }
        #else
        let library = fallbackLibrary
        #endif
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
