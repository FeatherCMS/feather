import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct NewsletterIssueAddView: Component {
    struct State {
        let subject: String
        let content: String
        let scheduledAt: String
        let newsletterId: String
        let issueId: String?
        let error: String?
    }
    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        let action =
            state.issueId.map {
                NewsletterAdminRoutes.issueEdit(
                    newsletterID: RouterPath(state.newsletterId),
                    issueID: RouterPath($0)
                )
                .description
            }
            ?? NewsletterAdminRoutes.issueAdd(RouterPath(state.newsletterId))
            .description
        return Section {
            context.render(
                NewAdminBreadcrumb(
                    links: NewsletterAdminRoutes.breadcrumb + [
                        .init(
                            label: "Campaign issues",
                            link:
                                NewsletterAdminRoutes.campaignIssues(
                                    RouterPath(state.newsletterId)
                                )
                                .description
                        ),
                        .init(
                            label: state.issueId == nil ? "Add" : "Edit",
                            link: action
                        ),
                    ]
                )
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: state.issueId == nil
                            ? "Add campaign issue" : "Edit campaign issue",
                        description:
                            "Compose the issue content and delivery schedule."
                    )
                )
            )
            context.render(
                NewAdminTabBar(links: [
                    .init(
                        label: "Details",
                        href:
                            NewsletterAdminRoutes.campaignDetails(
                                RouterPath(state.newsletterId)
                            )
                            .description,
                        isCurrent: false
                    ),
                    .init(
                        label: "Subscribers",
                        href:
                            NewsletterAdminRoutes.campaignSubscribers(
                                RouterPath(state.newsletterId)
                            )
                            .description,
                        isCurrent: false
                    ),
                    .init(
                        label: "Issues",
                        href:
                            NewsletterAdminRoutes.campaignIssues(
                                RouterPath(state.newsletterId)
                            )
                            .description,
                        isCurrent: true
                    ),
                ])
            )
            let form = NewAdminForm(action: action) {
                if let error = state.error {
                    P(error).class("new-admin-form__error")
                }
                context.render(
                    NewAdminFormFieldInput(
                        state: .init(
                            name: "subject",
                            label: "Subject",
                            value: state.subject,
                            isRequired: true
                        )
                    )
                )
                context.render(
                    NewAdminFormFieldTextArea(
                        state: .init(
                            name: "content",
                            label: "Content",
                            value: state.content,
                            style: .large,
                            isRequired: true
                        )
                    )
                )
                context.render(
                    NewAdminFormFieldInput(
                        state: .init(
                            name: "scheduledAt",
                            label: "Schedule",
                            value: state.scheduledAt,
                            help: "Optional Unix timestamp."
                        )
                    )
                )
                Div {
                    context.render(
                        NewAdminSubmitButton(
                            state.issueId == nil ? "Add issue" : "Save issue",
                            style: .primary
                        )
                    )
                }
                .class("new-admin-form__actions")
            }
            context.render(form)
            Div {
                context.render(
                    NewAdminControlButton("Send test email", style: .secondary)
                )
                .data("newsletter-test-email-open", "newsletterTestEmailModal")
            }
            .class("new-admin-form__actions")
            Div {
                Div {
                    Div {
                        H3("Send test email")
                        context.render(
                            NewAdminControlButton(
                                "Close",
                                style: .ghost(.primary)
                            )
                        )
                        .data(
                            "newsletter-test-email-close",
                            "newsletterTestEmailModal"
                        )
                    }
                    .class("newsletter-test-email-lightbox-header")
                    context.render(
                        NewAdminForm(
                            action: state.issueId.map {
                                NewsletterAdminRoutes.issueTestEmail(
                                    newsletterID: RouterPath(
                                        state.newsletterId
                                    ),
                                    issueID: RouterPath($0)
                                )
                                .description
                            }
                                ?? NewsletterAdminRoutes
                                .issueTestEmailSelectedRoute.description,
                            hiddenFields: [
                                .init(name: "subject", value: state.subject),
                                .init(name: "content", value: state.content),
                            ]
                        ) {
                            context.render(
                                NewAdminFormFieldInput(
                                    state: .init(
                                        name: "email",
                                        label: "Test email address",
                                        type: .email,
                                        isRequired: true
                                    )
                                )
                            )
                            Div {
                                context.render(
                                    NewAdminSubmitButton(
                                        "Send",
                                        style: .primary
                                    )
                                )
                            }
                            .class("new-admin-form__actions")
                        }
                    )
                }
                .class("newsletter-test-email-lightbox-card")
            }
            .id("newsletterTestEmailModal")
            .class("newsletter-test-email-lightbox")
            Style(
                """
                    .newsletter-test-email-lightbox { display: none; position: fixed; inset: 0; z-index: 1000; align-items: center; justify-content: center; background: rgb(0 0 0 / .7); padding: 1rem; }
                    .newsletter-test-email-lightbox.is-visible { display: flex; }
                    .newsletter-test-email-lightbox-card { width: min(32rem, 100%); background: var(--cms-white); color: var(--cms-strong-font); padding: 1.5rem; border-radius: .5rem; box-shadow: 0 1rem 3rem rgb(15 23 42 / .22); }
                    .newsletter-test-email-lightbox-header { display: flex; align-items: center; justify-content: space-between; gap: 1rem; margin-bottom: 1rem; }
                """
            )
            Script(
                """
                    (function() { var modal = document.getElementById('newsletterTestEmailModal'); if (!modal) return; document.querySelectorAll('[data-newsletter-test-email-open="newsletterTestEmailModal"]').forEach(function(button) { button.addEventListener('click', function() { modal.classList.add('is-visible'); modal.querySelector('input[name="email"]').focus(); }); }); document.querySelectorAll('[data-newsletter-test-email-close="newsletterTestEmailModal"]').forEach(function(button) { button.addEventListener('click', function() { modal.classList.remove('is-visible'); }); }); modal.addEventListener('click', function(event) { if (event.target === modal) modal.classList.remove('is-visible'); }); }());
                """
            )
        }
        .class("cms-section")
    }
}
