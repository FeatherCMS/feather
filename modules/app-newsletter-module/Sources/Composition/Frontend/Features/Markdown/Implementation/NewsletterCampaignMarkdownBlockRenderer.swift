import HTML
import SGML
import WebBuilders
import WebFrontend

struct NewsletterCampaignMarkdownBlockRenderer: WebMarkdownBlockRenderer {
    let name = "NewsletterCampaign"
    let usesFormSubmissionNonce = true
    let submissionRoute: NewsletterSubscriptionRoute
    let formChallengeProvider: (any WebFormChallengeProvider)?

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
        let action = submissionRoute.actionPath(for: identifier)
        var children: [any Element] = []
        if
            let feedback = request.formSubmissionFeedback,
            feedback.source == .newsletter,
            feedback.key == identifier
        {
            let message = feedback.status == .success
                ? "You are subscribed to the newsletter."
                : "Your subscription could not be completed. Please try again."
            let messageClass = feedback.status == .success
                ? "web-form-feedback web-form-feedback--success"
                : "web-form-feedback web-form-feedback--failure"
            children.append(P(message).setClass(messageClass))
        }
        children.append(
            Label {
                Span("Email")
                Input()
                    .type(.email)
                    .name("email")
                    .required()
            }
        )
        children.append(
            Input().type(.hidden).name("nonce").value(nonce)
        )
        if let formChallengeProvider {
            children.append(
                Div {
                    for element in formChallengeProvider.widget() {
                        element
                    }
                }
                .setClass("web-form-challenge")
            )
        }
        children.append(Button("Subscribe").type(.submit))
        let form = Form { children }
            .method(.post)
            .action(action)
            .data(
                "challenge-response-field-name",
                formChallengeProvider?.responseFieldName ?? ""
            )
            .setClass("newsletter-subscription-form")
        return Document(root: form).render()
    }
}
