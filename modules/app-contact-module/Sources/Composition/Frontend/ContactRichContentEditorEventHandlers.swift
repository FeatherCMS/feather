import FeatherAdmin
public import FeatherContracts

public enum ContactRichContentEditorEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: AdminRichContentEditorBlockProvider.self,
            context: AdminEventContext.self
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
