import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import SystemFrontend
import FeatherAdmin
import ContactAppAPI
import Foundation

struct ContactFormBlockRenderer: MarkdownBlockRenderer {
    let name = "ContactForm"
    let api: AppAPI

    func render(
        identifier: String,
        requestPath: String
    ) async -> String? {
        do {
            let response =
                try await api.withContactOpenAPIRepositoryErrorMapping {
                    client in
                    try await client.appContactFormGet(
                        path: .init(contactFormId: identifier)
                    )
                }
            guard case .ok(let value) = response else { return nil }
            let form = try value.body.json
            return render(form: form)
        }
        catch {
            return nil
        }
    }

    private func render(
        form: ContactAppAPI.Components.Schemas.AppContactFormSchema
    ) -> String {
        let fields = form.items.sorted { $0.position < $1.position }
            .map(renderField).joined()
        return
            "<form method=\"post\" action=\"/contact/forms/\(escape(form.id))/submissions\" class=\"contact-form\">\(fields)<button type=\"submit\">Submit</button></form>"
    }

    private func renderField(
        _ field: ContactAppAPI.Components.Schemas.AppFormFieldSchema
    ) -> String {
        let required = field.isRequired ? " required" : ""
        let label =
            "<label for=\"contact-form-\(escape(field.key))\">\(escape(field.label))</label>"
        switch field._type {
        case "textarea":
            return
                "<div class=\"contact-form-field\">\(label)<textarea id=\"contact-form-\(escape(field.key))\" name=\"values[\(escape(field.key))]\"\(required)></textarea></div>"
        case "select":
            let options = (field.allowedValues ?? [])
                .map {
                    "<option value=\"\(escape($0))\">\(escape($0))</option>"
                }
                .joined()
            return
                "<div class=\"contact-form-field\">\(label)<select id=\"contact-form-\(escape(field.key))\" name=\"values[\(escape(field.key))]\"\(required)>\(options)</select></div>"
        case "radio":
            let options = (field.allowedValues ?? [])
                .map {
                    "<label><input type=\"radio\" name=\"values[\(escape(field.key))]\" value=\"\(escape($0))\"\(required)>\(escape($0))</label>"
                }
                .joined()
            return
                "<fieldset class=\"contact-form-field\"><legend>\(escape(field.label))</legend>\(options)</fieldset>"
        case "toggle":
            return
                "<label class=\"contact-form-field\"><input type=\"checkbox\" id=\"contact-form-\(escape(field.key))\" name=\"values[\(escape(field.key))]\" value=\"true\"\(required)>\(escape(field.label))</label>"
        default:
            return
                "<div class=\"contact-form-field\">\(label)<input type=\"text\" id=\"contact-form-\(escape(field.key))\" name=\"values[\(escape(field.key))]\"\(required)></div>"
        }
    }

    private func escape(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }
}
