import FeatherAdmin
public import FeatherContracts

public enum NewsletterRichContentEditorEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: AdminRichContentEditorBlockProvider.self,
            context: AdminEventContext.self
        ) { _, _ in
            AdminRichContentEditorBlockDefinition(
                type: "newsletter",
                title: "Newsletter campaign",
                icon: "✉",
                directive: "NewsletterCampaign",
                pickerEndpoint: "/admin/newsletter/campaigns/?picker=1"
            )
        }
    }
}
