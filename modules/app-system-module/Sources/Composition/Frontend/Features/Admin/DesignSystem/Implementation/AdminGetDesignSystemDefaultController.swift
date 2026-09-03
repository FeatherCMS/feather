import CSS
import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetDesignSystemDefaultController: AdminGetDesignSystemController {
    func getDesignSystem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let body = Body {
            AdminGetDesignSystemComponent()
        }

        let collector = ComponentStylesheetCollector()
        let renderer = StylesheetRenderer(minify: false, indent: 4)
        let css = renderer.render(collector.getStylesheet(from: body))
        let origins = AppEnvironmentStore.current.publicOrigins

        let head = Head {
            Metadata(
                canonicalUrl: "\(origins.siteBaseURL)/admin/design-system/",
                title: "Design System",
                description: "Feather admin design-system component showcase",
                imageUrl: "\(origins.staticBaseURL)/images/logos/logo.png",
                noIndex: true
            )
            Style(css)
        }

        return .init(
            Html {
                head
                body
            }
            .lang("en-US")
        )
    }
}
