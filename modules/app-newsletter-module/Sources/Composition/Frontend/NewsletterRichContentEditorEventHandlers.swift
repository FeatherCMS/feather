import FeatherAdmin
public import FeatherModuleKit
import SystemModule
import SystemModuleWebAdmin

public enum NewsletterRichContentEditorEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: AdminRichContentEditorBlockProvider.self,
            context: SystemModuleWebAdmin.Events.Context.self
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
