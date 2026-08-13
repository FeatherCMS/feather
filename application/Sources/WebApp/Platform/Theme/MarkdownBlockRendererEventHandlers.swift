import FeatherContracts
import ContactFrontend
import NewsletterFrontend
import WebApplication

enum MarkdownBlockRendererEventHandlers {
    static func register(
        in registry: inout EventRegistry,
        api: ApplicationAPI
    ) {
        registry.register(
            event: WebMarkdownBlockRendererProvider.self,
            context: WebMarkdownBlockRendererRequest.self
        ) { _, _ in
            ContactFormBlockRenderer(api: api)
        }
        registry.register(
            event: WebMarkdownBlockRendererProvider.self,
            context: WebMarkdownBlockRendererRequest.self
        ) { _, _ in
            NewsletterCampaignBlockRenderer(api: api)
        }
    }
}
