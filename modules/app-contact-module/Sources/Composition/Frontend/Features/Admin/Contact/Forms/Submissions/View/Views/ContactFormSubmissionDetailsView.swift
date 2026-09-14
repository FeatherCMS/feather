import FeatherAdmin
import FeatherContracts
import ContactContracts
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
        let isEdited: Bool
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let permissions: NewAdminListActions
    }
    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        let canUpdate = state.permissions.allows(ContactPermissions.Submissions.update)
        return Section {
            context.render(AdminContactFormTabs(formId: state.formId, active: .submissions))
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(NewAdminPageHeader(state: .init(title: "Contact form submission", description: "Review the submitted values and processing status.")))
            if let error = state.error { P(error).class("new-admin-form__error") }
            if state.isEdited { context.render(NewAdminNotification(notification: .init(title: "Submission updated", message: "Submission status updated successfully."))) }
            context.render(NewAdminDetailField(label: "Submitted", value: state.item.createdAt.isEmpty ? "—" : state.item.createdAt))
            context.render(NewAdminDetailField(label: "Email", value: state.item.email ?? "—"))
            H2("Values")
            if state.item.values.isEmpty { context.render(NewAdminListEmptyState(message: "No values recorded.", icon: FeatherIcons.inbox())) }
            else {
                Table { Tbody { for (key, value) in state.item.values.sorted(by: { $0.key < $1.key }) { Tr { Th(key); Td(value).data("label", key) } } } }.class("cms-table")
            }
            if canUpdate {
                let form = NewAdminForm(action: ContactAdminRoutes.formSubmissionDetails(formID: RouterPath(state.formId), submissionID: RouterPath(state.item.id)).description) {
                    context.render(NewAdminFormFieldSelect(state: .init(name: "status", label: "Status", value: state.item.status, options: [
                        .init(label: "Received", value: "received"),
                        .init(label: "Processed", value: "processed"),
                        .init(label: "Spam", value: "spam"),
                        .init(label: "Failed", value: "failed"),
                    ], isRequired: true)))
                    Div { context.render(NewAdminSubmitButton("Save status")) }.class("new-admin-form__actions")
                }
                context.render(form)
            }
        }.class("cms-section")
    }
}
