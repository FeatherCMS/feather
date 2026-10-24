import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

extension Issue.Form {
    struct View: Component {
        struct State {
            let subject: String
            let content: String
            let scheduledAt: String
            let newsletterId: String
            let issueId: String?
            let error: String?
            let pageHeader: AdminPageHeader.State
            let routes: Campaign.Router.Routes
        }
        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            let action =
                state.issueId.map {
                    state.routes.issueEditPath(
                        newsletterId: state.newsletterId,
                        issueId: $0
                    )
                } ?? state.routes.issueAddPath(newsletterId: state.newsletterId)
            return Section {
                context.build(
                    AdminBreadcrumb(
                        links: state.routes.breadcrumb + [
                            .init(
                                label: "Campaign issues",
                                link: state.routes.issuesPath(
                                    newsletterId: state.newsletterId
                                )
                            ),
                            .init(
                                label: state.issueId == nil ? "Add" : "Edit",
                                link: action
                            ),
                        ]
                    )
                )
                context.build(AdminPageHeader(state: state.pageHeader))
                context.build(
                    Campaign.Tabs(
                        id: state.newsletterId,
                        active: .issues
                    )
                )
                let form = AdminForm(action: action) {
                    if let error = state.error {
                        P(error).class("admin-form__error")
                    }
                    context.build(
                        AdminFormFieldInput(
                            state: .init(
                                name: "subject",
                                label: "Subject",
                                value: state.subject,
                                isRequired: true
                            )
                        )
                    )
                    context.build(
                        AdminFormFieldTextArea(
                            state: .init(
                                name: "content",
                                label: "Content",
                                value: state.content,
                                style: .large,
                                isRequired: true
                            )
                        )
                    )
                    context.build(
                        AdminFormFieldDatePicker(
                            state: .init(
                                name: "scheduledAt",
                                label: "Schedule",
                                value: state.scheduledAt
                            )
                        )
                    )
                    Div {
                        context.build(
                            AdminSubmitButton(
                                state.issueId == nil
                                    ? "Add issue" : "Save issue",
                                style: .primary
                            )
                        )
                        context.build(
                            AdminControlButton(
                                "Send test email",
                                style: .secondary
                            )
                        )
                        .data(
                            "newsletter-test-email-open",
                            "newsletterTestEmailModal"
                        )
                    }
                    .class("admin-form__actions")
                }
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Issue content",
                            description:
                                "Compose the subject, message, and delivery schedule."
                        )
                    ) {
                        context.build(form)
                    }
                )
                Div {
                    Div {
                        Div {
                            H3("Send test email")
                            context.build(
                                AdminControlButton(
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
                        context.build(
                            AdminForm(
                                action: state.issueId.map {
                                    state.routes.issueDetailTestEmailPath(
                                        newsletterId: state.newsletterId,
                                        issueId: $0
                                    )
                                }
                                    ?? state.routes.issueTestEmailPath(
                                        newsletterId: state.newsletterId
                                    ),
                                hiddenFields: [
                                    .init(
                                        name: "subject",
                                        value: state.subject
                                    ),
                                    .init(
                                        name: "content",
                                        value: state.content
                                    ),
                                ]
                            ) {
                                context.build(
                                    AdminFormFieldInput(
                                        state: .init(
                                            name: "email",
                                            label: "Test email address",
                                            type: .email,
                                            isRequired: true
                                        )
                                    )
                                )
                                Div {
                                    context.build(
                                        AdminSubmitButton(
                                            "Send",
                                            style: .primary
                                        )
                                    )
                                }
                                .class("admin-form__actions")
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
                        .newsletter-test-email-lightbox-card { --material-color-primary-tint: #fff; --material-color-primary-text: #000; --material-color-primary-border: #d8dee7; --material-color-primary-hover: #f5f6f8; --material-color-secondary-tint: #f8fafc; --material-color-secondary-text: #111827; --material-color-secondary-border: #edf0f4; --material-color-secondary-hover: #edf0f4; --material-color-tertiary-tint: #f2f2f7; --material-color-tertiary-text: #374151; --material-color-tertiary-border: #d9dce1; --material-color-tertiary-hover: #e6e8eb; width: min(32rem, 100%); background: #fff; color: #000; color-scheme: light; padding: 1.5rem; border-radius: .5rem; box-shadow: 0 1rem 3rem rgb(15 23 42 / .22); }
                        .newsletter-test-email-lightbox-header { display: flex; align-items: center; justify-content: space-between; gap: 1rem; margin-bottom: 1rem; }
                    """
                )
                Script(
                    """
                        (function() { var modal = document.getElementById('newsletterTestEmailModal'); if (!modal) return; document.querySelectorAll('[data-newsletter-test-email-open="newsletterTestEmailModal"]').forEach(function(button) { button.addEventListener('click', function() { var issueForm = document.querySelector('.admin-form'); if (issueForm) { var subject = issueForm.querySelector('[name="subject"]'); var content = issueForm.querySelector('[name="content"]'); var testSubject = modal.querySelector('input[type="hidden"][name="subject"]'); var testContent = modal.querySelector('input[type="hidden"][name="content"]'); if (subject && testSubject) testSubject.value = subject.value; if (content && testContent) testContent.value = content.value; } modal.classList.add('is-visible'); modal.querySelector('input[name="email"]').focus(); }); }); document.querySelectorAll('[data-newsletter-test-email-close="newsletterTestEmailModal"]').forEach(function(button) { button.addEventListener('click', function() { modal.classList.remove('is-visible'); }); }); modal.addEventListener('click', function(event) { if (event.target === modal) modal.classList.remove('is-visible'); }); }());
                    """
                )
            }
            .class("cms-section")
        }
    }
}
