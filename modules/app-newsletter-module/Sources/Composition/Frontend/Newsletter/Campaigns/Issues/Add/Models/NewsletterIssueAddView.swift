import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct NewsletterIssueAddView: Leaf {
    struct State {
        let subject: String
        let content: String
        let scheduledAt: String
        let newsletterId: String
        let issueId: String?
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State
    func html() -> some BasicTag {
        Section {
            AdminNewsletterCampaignTabs(
                campaignId: state.newsletterId,
                active: .issues
            ).html()
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1(
                state.issueId == nil
                    ? "Add campaign issue" : "Edit campaign issue"
            )
            if let error = state.error { P(error).class("error") }
            Form {
                Label {
                    AdminFieldLabel(label: "Subject", required: true).html()
                    Input().type(.text).class("text-input").name("subject")
                        .value(state.subject).required()
                }
                Label {
                    AdminFieldLabel(label: "Content", required: true).html()
                    Textarea(state.content).class("text-input").name("content")
                        .required()
                }
                Label {
                    AdminFieldLabel(
                        label: "Schedule (optional)",
                        required: false
                    ).html()
                    Input().type(.text).class("text-input").name("scheduledAt")
                        .value(state.scheduledAt).placeholder("Unix timestamp")
                }
                Div {
                    Button(state.issueId == nil ? "Add" : "Save").type(.submit)
                }
                .class("button-row")
            }
            .method(.post)
            .action(
                state.issueId.map {
                    "/admin/newsletters/\(state.newsletterId)/issues/\($0)/edit/"
                } ?? "/admin/newsletters/\(state.newsletterId)/issues/add/"
            )
            .class("cms-form")
            Button("Send test email")
                .type(.button)
                .class("secondary")
                .data("newsletter-test-email-open", "newsletterTestEmailModal")
            Div {
                Div {
                    Div {
                        H3("Send test email")
                        Button("Close").type(.button).class("ghost")
                            .data(
                                "newsletter-test-email-close",
                                "newsletterTestEmailModal"
                            )
                    }
                    .class("newsletter-test-email-lightbox-header")
                    Form {
                        Input().type(.hidden).name("subject")
                            .value(state.subject)
                        Input().type(.hidden).name("content")
                            .value(state.content)
                        Label {
                            AdminFieldLabel(
                                label: "Test email address",
                                required: true
                            ).html()
                            Input().type(.email).class("text-input")
                                .name("email").required()
                        }
                        Div { Button("Send").type(.submit) }.class("button-row")
                    }
                    .method(.post)
                    .action(
                        state.issueId.map {
                            "/admin/newsletters/\(state.newsletterId)/issues/\($0)/test-email/"
                        }
                            ?? "/admin/newsletters/\(state.newsletterId)/issues/test-email/"
                    )
                    .class("cms-form")
                }
                .class("newsletter-test-email-lightbox-card")
            }
            .id("newsletterTestEmailModal")
            .class("newsletter-test-email-lightbox")
            Style(
                """
                    .newsletter-test-email-lightbox { display: none; position: fixed; inset: 0; z-index: 1000; align-items: center; justify-content: center; background: rgba(0, 0, 0, .55); padding: 1rem; }
                    .newsletter-test-email-lightbox.is-visible { display: flex; }
                    .newsletter-test-email-lightbox-card { width: min(32rem, 100%); background: var(--cms-white); color: var(--cms-strong-font); border: 1px solid var(--cms-gray-3); padding: 1.5rem; border-radius: .5rem; box-shadow: 0 1rem 3rem rgb(15 23 42 / 0.22); }
                    .newsletter-test-email-lightbox-header { display: flex; align-items: center; justify-content: space-between; gap: 1rem; margin-bottom: 1rem; }
                    .newsletter-test-email-lightbox-header h3 { margin: 0; }
                """
            )
            Script(
                """
                    (function() {
                        var modal = document.getElementById('newsletterTestEmailModal');
                        if (!modal) return;
                        document.querySelectorAll('[data-newsletter-test-email-open="newsletterTestEmailModal"]').forEach(function(button) {
                            button.addEventListener('click', function() { modal.classList.add('is-visible'); modal.querySelector('input[name="email"]').focus(); });
                        });
                        document.querySelectorAll('[data-newsletter-test-email-close="newsletterTestEmailModal"]').forEach(function(button) {
                            button.addEventListener('click', function() { modal.classList.remove('is-visible'); });
                        });
                        modal.addEventListener('click', function(event) { if (event.target === modal) modal.classList.remove('is-visible'); });
                    }());
                """
            )
        }
        .class("cms-section")
    }
}
