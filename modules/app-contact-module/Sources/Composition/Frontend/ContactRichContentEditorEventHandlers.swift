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
                pickerEndpoint: "/admin/contact/forms/?picker=1",
                isContainer: true
            )
        }
        for definition in [
            AdminRichContentEditorBlockDefinition(
                type: "contact-form-field",
                title: "Contact form field",
                icon: "▤",
                directive: "ContactFormField",
                editor: .text,
                isContainerChild: true
            ),
            AdminRichContentEditorBlockDefinition(
                type: "contact-form-captcha",
                title: "Contact form CAPTCHA",
                icon: "◉",
                directive: "ContactFormCaptcha",
                editor: .marker,
                isContainerChild: true
            ),
            AdminRichContentEditorBlockDefinition(
                type: "contact-form-error",
                title: "Contact form error message",
                icon: "!",
                directive: "ContactFormError",
                editor: .marker,
                isContainerChild: true
            ),
            AdminRichContentEditorBlockDefinition(
                type: "contact-form-success",
                title: "Contact form success message",
                icon: "✓",
                directive: "ContactFormSuccess",
                editor: .marker,
                isContainerChild: true
            ),
            AdminRichContentEditorBlockDefinition(
                type: "contact-form-submit",
                title: "Contact form submit button",
                icon: "➜",
                directive: "ContactFormSubmit",
                editor: .marker,
                isContainerChild: true
            ),
        ] {
            registry.register(
                event: AdminRichContentEditorBlockProvider.self,
                context: AdminEventContext.self
            ) { _, _ in definition }
        }
    }
}
