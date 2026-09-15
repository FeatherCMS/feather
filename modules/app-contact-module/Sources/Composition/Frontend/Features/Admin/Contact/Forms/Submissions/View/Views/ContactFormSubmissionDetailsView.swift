import ContactContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormSubmissionDetailsView: Component {
    struct State {
        let formId: String
        let item: AdminContactFormSubmissionItem
        let error: String?
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let permissions: NewAdminListActions
    }
    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        let canUpdate = state.permissions.allows(
            ContactPermissions.Submissions.update
        )
        return Section {
            context.build(
                AdminContactFormTabs(formId: state.formId, active: .submissions)
            )
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Contact form submission",
                        description:
                            "Review the submitted values and processing status."
                    )
                )
            )
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.build(
                NewAdminDetailField(
                    label: "Submitted",
                    value: state.item.createdAt.isEmpty
                        ? "—" : state.item.createdAt
                )
            )
            context.build(
                NewAdminDetailField(
                    label: "Email",
                    value: state.item.email ?? "—"
                )
            )
            H2("Values")
            if state.item.values.isEmpty {
                context.build(
                    NewAdminListEmptyState(
                        message: "No values recorded.",
                        icon: FeatherIcons.inbox()
                    )
                )
            }
            else {
                Table {
                    Tbody {
                        for (key, value) in state.item.values.sorted(by: {
                            $0.key < $1.key
                        }) {
                            Tr {
                                Th(key)
                                Td(value).data("label", key)
                            }
                        }
                    }
                }
                .class("cms-table")
            }
            if canUpdate {
                let form = NewAdminForm(
                    action:
                        ContactAdminRoutes.formSubmissionDetails(
                            formID: RouterPath(state.formId),
                            submissionID: RouterPath(state.item.id)
                        )
                        .description
                ) {
                    context.build(
                        NewAdminFormFieldSelect(
                            state: .init(
                                name: "status",
                                label: "Status",
                                value: state.item.status,
                                options: [
                                    .init(label: "Received", value: "received"),
                                    .init(
                                        label: "Processed",
                                        value: "processed"
                                    ),
                                    .init(label: "Spam", value: "spam"),
                                    .init(label: "Failed", value: "failed"),
                                ],
                                isRequired: true
                            )
                        )
                    )
                    Div { context.build(NewAdminSubmitButton("Save status")) }
                        .class("new-admin-form__actions")
                }
                context.build(form)
            }
        }
        .class("cms-section")
    }
}
