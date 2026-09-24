public import FeatherAdmin
import Mustache

public struct DefaultThemeRenderer: PublicThemeRenderer {

    private let fallbackLibrary: MustacheLibrary
    private let fallbackTemplateMetadata: [String: TemplateMetadata]
    private let templateLoader: any TemplateLoader
    private let templatePath: @Sendable (String) -> String?
    private let layoutTemplate = "html"

    public init(
        templateLoader: any TemplateLoader,
        templatePath: @escaping @Sendable (String) -> String?
    ) throws {
        self.fallbackLibrary = .init(templates: try templateLoader.load())
        self.fallbackTemplateMetadata = try templateLoader.loadMetadata()
        self.templateLoader = templateLoader
        self.templatePath = templatePath
    }

    public func render(
        templateIdentifier: String?,
        context: [String: any Sendable]
    ) -> HTMLResponse {
        #if DEBUG
        let library: MustacheLibrary
        let templateMetadata: [String: TemplateMetadata]
        if let templates = try? templateLoader.load() {
            library = .init(templates: templates)
        }
        else {
            library = fallbackLibrary
        }
        templateMetadata =
            (try? templateLoader.loadMetadata()) ?? fallbackTemplateMetadata
        #else
        let library = fallbackLibrary
        let templateMetadata = fallbackTemplateMetadata
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
        var pageContext =
            (layoutContext["page"] as? [String: any Sendable]) ?? [:]
        let metadata = templateMetadata[template] ?? .init()
        pageContext["autoStylesheets"] = metadata.stylesheets.map {
            assetURL($0, context: context)
        }
        pageContext["autoScripts"] = metadata.scripts.map {
            assetURL($0, context: context)
        }
        layoutContext["page"] = pageContext
        layoutContext["body"] = body
        let html =
            library.render(layoutContext, withTemplate: layoutTemplate)
            ?? "<!DOCTYPE html><html lang=\"en-US\"><body><p>Theme render failed.</p></body></html>"
        return .init(content: html)
    }

    private func assetURL(
        _ path: String,
        context: [String: any Sendable]
    ) -> String {
        guard
            !path.hasPrefix("/")
                && !path.hasPrefix("http://")
                && !path.hasPrefix("https://")
        else {
            return path
        }
        guard let staticBaseURL = context["staticBaseUrl"] as? String else {
            return "/\(path)"
        }
        return "\(staticBaseURL.trimmingTrailingSlash)/\(path)"
    }
}

private extension String {

    var trimmingTrailingSlash: String {
        var result = self
        while result.hasSuffix("/") {
            result.removeLast()
        }
        return result
    }
}
