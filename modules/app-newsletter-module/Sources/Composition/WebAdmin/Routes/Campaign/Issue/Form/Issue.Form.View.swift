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
                        links: state.routes.campaignBreadcrumb
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
                            "admin-dialog-url",
                            state.issueId.map {
                                state.routes.issueDetailTestEmailPath(
                                    newsletterId: state.newsletterId,
                                    issueId: $0
                                )
                            }
                                ?? state.routes.issueTestEmailPath(
                                    newsletterId: state.newsletterId
                                )
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
            }
            .class("cms-section")
        }
    }
}
