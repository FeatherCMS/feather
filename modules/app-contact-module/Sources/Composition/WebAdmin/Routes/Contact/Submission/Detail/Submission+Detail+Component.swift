import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension Submission.Detail {
    struct DetailsView: Component {
        struct State {
            let formId: String
            let item: Submission.Item
            let error: String?
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Contact.Router.Routes
            let permissions: AdminListActions
        }
        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            let canUpdate = state.permissions.allows(
                Submission.Permissions.update
            )
            return Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Contact form submission",
                            description:
                                "Review the submitted values and processing status."
                        )
                    )
                )
                context.build(
                    AdminContactFormTabs(
                        formId: state.formId,
                        active: .submissions
                    )
                )
                if let error = state.error {
                    P(error).class("admin-form__error")
                }
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Submission details",
                            description:
                                "Review the submitted values and processing status."
                        )
                    ) {
                        context.build(
                            AdminDetailField(
                                label: "Submitted",
                                value: state.item.createdAt.isEmpty
                                    ? "—" : state.item.createdAt
                            )
                        )
                        context.build(
                            AdminDetailField(
                                label: "Email",
                                value: state.item.email ?? "—"
                            )
                        )
                        H2("Values")
                        if state.item.values.isEmpty {
                            context.build(
                                AdminListEmptyState(
                                    message: "No values recorded.",
                                    icon: FeatherIcons.inbox()
                                )
                            )
                        }
                        else {
                            for (key, value) in state.item.values.sorted(by: {
                                $0.key < $1.key
                            }) {
                                context.build(
                                    AdminDetailField(label: key, value: value)
                                )
                            }
                        }
                        if canUpdate {
                            let form = AdminForm(
                                action: state.routes.formSubmissionDetailPath(
                                    formKey: state.formId,
                                    submissionId: state.item.id
                                )
                            ) {
                                context.build(
                                    AdminFormFieldSelect(
                                        state: .init(
                                            name: "status",
                                            label: "Status",
                                            value: state.item.status,
                                            options: [
                                                .init(
                                                    label: "Received",
                                                    value: "received"
                                                ),
                                                .init(
                                                    label: "Processed",
                                                    value: "processed"
                                                ),
                                                .init(
                                                    label: "Spam",
                                                    value: "spam"
                                                ),
                                                .init(
                                                    label: "Failed",
                                                    value: "failed"
                                                ),
                                            ],
                                            isRequired: true
                                        )
                                    )
                                )
                                Div {
                                    context.build(
                                        AdminSubmitButton("Save status")
                                    )
                                }
                                .class("admin-form__actions")
                            }
                            context.build(form)
                        }
                    }
                )
            }
            .class("cms-section")
        }
    }
}
