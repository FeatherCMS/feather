import FeatherContracts
import WebFrontend

public enum NewsletterMarkdownEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: WebMarkdownBlockRendererProvider.self,
            context: WebMarkdownBlockRendererRequest.self
        ) { _, _ in
            NewsletterCampaignMarkdownBlockRenderer()
        }
    }
}
