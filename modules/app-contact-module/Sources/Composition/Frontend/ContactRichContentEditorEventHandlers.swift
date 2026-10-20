import FeatherAdmin
public import FeatherModuleKit
import SystemModule
import SystemModuleWebAdmin

public enum ContactRichContentEditorEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: AdminRichContentEditorBlockProvider.self,
            context: SystemModuleWebAdmin.Events.Context.self
        ) { _, _ in
            AdminRichContentEditorBlockDefinition(
                type: "contact-form",
                title: "Contact form",
                icon: "☏",
                directive: "ContactForm",
                pickerEndpoint: "/admin/contact/forms/?picker=1"
            )
        }
    }
}
