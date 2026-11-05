public import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import SystemModule
import SystemWebAdmin

extension Event.Handlers {
    public static func registerRichContentEditor(
        in registry: inout EventRegistry,
        routes: Contact.Router.Routes
    ) {
        registry.register(
            event: AdminRichContentEditorBlockProvider.self,
            context: SystemWebAdmin.Admin.Menu.Context.self
        ) { _, _ in
            var components = URLComponents()
            components.path = routes.forms.path
            components.queryItems = [
                URLQueryItem(name: "picker", value: "1")
            ]
            return AdminRichContentEditorBlockDefinition(
                type: "contact-form",
                title: "Contact form",
                icon: "☏",
                directive: "ContactForm",
                pickerEndpoint: components.string ?? components.path,
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
                context: SystemWebAdmin.Admin.Menu.Context.self
            ) { _, _ in definition }
        }
    }
}
