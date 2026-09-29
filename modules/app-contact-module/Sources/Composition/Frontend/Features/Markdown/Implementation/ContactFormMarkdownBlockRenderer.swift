import ContactAppAPI
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebFrontend

struct ContactFormMarkdownBlockRenderer: WebMarkdownBlockRenderer {
    let name = "ContactForm"
    let usesFormSubmissionNonce = true
    let api: ContactAppAPIClient

    func render(
        request: WebMarkdownBlockRendererRequest
    ) async -> String? {
        guard
            let identifier = request.arguments["key"],
            !identifier.isEmpty,
            let nonce = request.formSubmissionNonce
        else {
            return nil
        }
        do {
            let response =
                try await api.withOpenAPIRepositoryErrorMapping {
                    client in
                    try await client.appContactFormGet(
                        path: .init(contactFormKey: identifier)
                    )
                }
            guard case .ok(let value) = response else { return nil }
            let form = try value.body.json
            return render(
                form: form,
                nonce: nonce,
                feedback: request.formSubmissionFeedback
            )
        }
        catch {
            return nil
        }
    }

    private func render(
        form: ContactAppAPI.Components.Schemas.AppContactFormSchema,
        nonce: String,
        feedback: WebFormSubmissionFeedback?
    ) -> String {
        let fields = form.items.sorted { $0.position < $1.position }
            .map(renderField)
        let action = ContactAppRoutes.submissionAction(for: form.key)
        var children: [any Element] = []
        children.append(Input().type(.hidden).name("nonce").value(nonce))
        if
            let feedback,
            feedback.source == .contact,
            feedback.key == form.key
        {
            let message: String
            let messageClass: String
            switch feedback.status {
            case .success:
                message = form.successMessage.isEmpty
                    ? "Your message has been sent."
                    : form.successMessage
                messageClass = "web-form-feedback web-form-feedback--success"
            case .failure:
                message = form.failureMessage.isEmpty
                    ? "Your message could not be sent. Please try again."
                    : form.failureMessage
                messageClass = "web-form-feedback web-form-feedback--failure"
            }
            children.append(P(message).setClass(messageClass))
        }
        children.append(contentsOf: fields)
        children.append(Button("Submit").type(.submit))
        let formElement = Form { children }
            .method(.post)
            .action(action)
            .setClass("contact-form")
        return Document(root: formElement).render()
    }

    private func renderField(
        _ field: ContactAppAPI.Components.Schemas.AppFormFieldSchema
    ) -> any Element {
        let name = "values[\(field.key)]"
        switch field._type {
        case "textarea":
            let textarea = Textarea("")
                .name(name)
            return Label {
                Span(field.label)
                if field.isRequired {
                    textarea.required()
                }
                else {
                    textarea
                }
            }
            .setClass("contact-form-field")
        case "select":
            let select = Select {
                for value in field.allowedValues ?? [] {
                    Option(value).value(value)
                }
            }
            .name(name)
            return Label {
                Span(field.label)
                if field.isRequired {
                    select.required()
                }
                else {
                    select
                }
            }
            .setClass("contact-form-field")
        case "radio":
            return Fieldset {
                Legend(field.label)
                for value in field.allowedValues ?? [] {
                    Label {
                        let input = Input()
                            .type(.radio)
                            .name(name)
                            .value(value)
                        if field.isRequired {
                            input.required()
                        }
                        else {
                            input
                        }
                        Span(value)
                    }
                }
            }
            .setClass("contact-form-field")
        case "toggle":
            let input = Input()
                .type(.checkbox)
                .name(name)
                .value("true")
            return Label {
                if field.isRequired {
                    input.required()
                }
                else {
                    input
                }
                Span(field.label)
            }
            .setClass("contact-form-field")
        case "hidden":
            return Input()
                .type(.hidden)
                .name(name)
                .value("true")
        default:
            let type: Input.Types = field.key.lowercased().contains("email")
                ? .email : .text
            let input = Input()
                .type(type)
                .name(name)
            return Label {
                Span(field.label)
                if field.isRequired {
                    input.required()
                }
                else {
                    input
                }
            }
            .setClass("contact-form-field")
        }
    }
}
