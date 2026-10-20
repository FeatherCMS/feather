import ContactAppAPI
import Foundation
import HTML
import Hummingbird
import Logging
import SGML
import WebBuilders
import WebFrontend

struct ContactFormMarkdownBlockRenderer: WebMarkdownBlockRenderer {
    let name = "ContactForm"
    let usesFormSubmissionNonce = true
    let api: ContactAppAPIClient
    let turnstileSiteKey: String?

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
            let displayMode = request.arguments["displayMode"]?.lowercased()
            let legacyMode = request.arguments["mode"]?.lowercased()
            let usesCustomLayout = displayMode == "custom"
                || (displayMode == nil && legacyMode == "custom")
            return render(
                form: form,
                nonce: nonce,
                feedback: request.formSubmissionFeedback,
                layoutChildren: usesCustomLayout ? request.children : nil
            )
        }
        catch {
            return nil
        }
    }

    private func render(
        form: ContactAppAPI.Components.Schemas.AppContactFormSchema,
        nonce: String,
        feedback: WebFormSubmissionFeedback?,
        layoutChildren: [WebMarkdownBlockRendererRequest.Child]? = nil
    ) -> String {
        let fields = form.items.sorted { $0.position < $1.position }
        let action = ContactAppRoutes.submissionAction(for: form.key)
        var children: [any Element] = []
        children.append(Input().type(.hidden).name("nonce").value(nonce))
        var customLayout: String?
        if let layoutChildren,
            let resolvedLayout = resolveLayout(
                layoutChildren,
                fields: fields,
                form: form,
                feedback: feedback
            )
        {
            customLayout = resolvedLayout
        }
        else {
            if layoutChildren != nil {
                Logger.current.warning(
                    "Invalid ContactForm Markdown layout; using the default field layout.",
                    metadata: ["formKey": .string(form.key)]
                )
            }
            if let feedbackElement = feedbackElement(
                feedback,
                form: form,
                status: nil
            ) {
                children.append(feedbackElement)
            }
            children.append(contentsOf: fields.map(renderField))
            appendCaptcha(to: &children)
            children.append(Button("Submit").type(.submit))
        }
        let formElement = Form { children }
            .method(.post)
            .action(action)
            .id("contact-form-\(form.key)")
            .data("contact-form", form.key)
            .setClass("contact-form")
        let renderedForm = Document(root: formElement).render()
        guard let customLayout else { return renderedForm }
        return renderedForm.replacingOccurrences(
            of: "</form>",
            with: customLayout + "</form>"
        )
    }

    private func resolveLayout(
        _ children: [WebMarkdownBlockRendererRequest.Child],
        fields: [ContactAppAPI.Components.Schemas.AppFormFieldSchema],
        form: ContactAppAPI.Components.Schemas.AppContactFormSchema,
        feedback: WebFormSubmissionFeedback?
    ) -> String? {
        let fieldsByKey = Dictionary(uniqueKeysWithValues: fields.map { ($0.key, $0) })
        var fieldCounts: [String: Int] = [:]
        var hasInvalidField = false
        var submitCount = 0
        var errorCount = 0
        var successCount = 0
        var captchaCount = 0

        func render(_ child: WebMarkdownBlockRendererRequest.Child) -> String? {
            switch child.name.lowercased() {
            case "contactformfield":
                guard let key = child.arguments["key"],
                    let field = fieldsByKey[key]
                else {
                    hasInvalidField = true
                    return nil
                }
                fieldCounts[key, default: 0] += 1
                return Document(root: renderField(field)).render()
            case "contactformsubmit":
                submitCount += 1
                return Document(root: Button("Submit").type(.submit)).render()
            case "contactformerror":
                errorCount += 1
                return feedbackElement(feedback, form: form, status: .failure)
                    .map { Document(root: $0).render() } ?? ""
            case "contactformsuccess":
                successCount += 1
                return feedbackElement(feedback, form: form, status: .success)
                    .map { Document(root: $0).render() } ?? ""
            case "contactformcaptcha":
                captchaCount += 1
                guard let turnstileSiteKey, !turnstileSiteKey.isEmpty else {
                    return ""
                }
                return Document(
                    root: Div {}.class("cf-turnstile")
                        .data("sitekey", turnstileSiteKey)
                ).render()
            case "grid":
                let cells = child.children.filter { $0.name.lowercased() == "cell" }
                guard !cells.isEmpty else { return nil }
                let desktop = columnCount(child.arguments["desktop"], fallback: 3)
                let tablet = columnCount(child.arguments["tablet"], fallback: 2)
                let mobile = columnCount(child.arguments["mobile"], fallback: 1)
                let renderedCells = cells.compactMap(render)
                    .map { "<div>\($0)</div>" }.joined()
                return "<div class=\"grid grid-\(desktop)\(tablet)\(mobile)\">\(renderedCells)</div>"
            case "cell":
                return child.children.compactMap(render).joined()
            default:
                return child.html
            }
        }

        let html = children.compactMap(render).joined()
        guard !hasInvalidField,
            fields.allSatisfy({ fieldCounts[$0.key] == 1 }),
            fieldCounts.count == fields.count,
            submitCount == 1,
            errorCount == 1,
            successCount == 1,
            captchaCount <= 1,
            turnstileSiteKey?.isEmpty != false || captchaCount == 1
        else { return nil }

        guard !html.isEmpty else { return nil }
        var result = html
        if let turnstileSiteKey, !turnstileSiteKey.isEmpty {
            result += Document(
                root: Script()
                    .src("https://challenges.cloudflare.com/turnstile/v0/api.js")
                    .async()
                    .defer()
            ).render()
        }
        return result
    }

    private func columnCount(_ value: String?, fallback: Int) -> Int {
        guard let value, let count = Int(value) else { return fallback }
        return max(1, min(4, count))
    }

    private func feedbackElement(
        _ feedback: WebFormSubmissionFeedback?,
        form: ContactAppAPI.Components.Schemas.AppContactFormSchema,
        status: WebFormSubmissionFeedback.Status?
    ) -> (any Element)? {
        guard
            let feedback,
            feedback.source == .contact,
            feedback.key == form.key,
            status == nil || feedback.status == status
        else {
            return nil
        }

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
        return P(message).setClass(messageClass).ariaLive(.polite)
    }

    private func appendCaptcha(to children: inout [any Element]) {
        guard let turnstileSiteKey, !turnstileSiteKey.isEmpty else { return }
        children.append(
            Div {}.class("cf-turnstile").data("sitekey", turnstileSiteKey)
        )
        children.append(
            Script()
                .src("https://challenges.cloudflare.com/turnstile/v0/api.js")
                .async()
                .defer()
        )
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
            let type: Input.Types =
                field.key.lowercased().contains("email")
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
