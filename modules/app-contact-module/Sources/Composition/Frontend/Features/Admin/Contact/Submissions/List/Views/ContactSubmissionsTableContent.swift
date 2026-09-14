import FeatherAdmin
import FeatherContracts
import ContactContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactSubmissionsTableContent: Component {
    let items: [AdminContactSubmissionDirectoryItem]
    let pageState: NewAdminListPageState
    let search: String
    let permissions: NewAdminListActions

    private var hasEmailColumn: Bool {
        items.contains { !($0.email?.isEmpty ?? true) }
    }


    func html(context: inout RenderContext) -> Div {
        let path = ContactAdminRoutes.submissions.description
                let returnTo = NewAdminLocation.url(path: path, page: pageState.page, search: search)
        return context.render(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange { context.render(NewAdminListInvalidPageState(pageState: pageState, path: path)) }
                    else if items.isEmpty {
                        context.render(NewAdminListEmptyState(message: search.isEmpty ? "No submissions yet." : "No submissions match your search.", icon: FeatherIcons.inbox(), action: {
                            if !search.isEmpty { context.render(NewAdminButton("Reset search", href: path, style: .secondary)) }
                        }))
                    }
                    else {
                        let canDelete = permissions.allows(ContactPermissions.Submissions.delete)
                        context.render(NewAdminListSelectionForm(
                            state: .init(action: ContactAdminRoutes.submissionRemove.description, pageState: pageState, search: search, button: .init("Remove selected", style: .destructive), isEnabled: canDelete),
                            table: context.render(NewAdminListShell(
                                layout: .init(name: "contact-submissions", columns: [.fraction(1), .fraction(1), .fraction(1), .fixed(150), .fixed(220)]), hasSelection: canDelete,
                                table: Table {
                                    Thead { Tr { if canDelete { context.render(NewAdminListSelectAllCheckbox()) }; Th("Form"); Th("Submitted"); if hasEmailColumn { Th("Email") }; Th("Status"); Th("Actions") } }
                                    Tbody {
                                        for item in items {
                                            Tr {
                                                if canDelete { context.render(NewAdminListRowCheckbox(id: "\(item.formId):\(item.id)")) }
                                                Td(item.formName).data("label", "Form")
                                                Td(item.createdAt).data("label", "Submitted")
                                                if hasEmailColumn { Td(item.email ?? "—").data("label", "Email") }
                                                Td(item.status).data("label", "Status")
                                                context.render(NewAdminListRowActions(label: "Actions", actions: [
                                                    .init("Details", href: ContactAdminRoutes.formSubmissionDetails(formID: RouterPath(item.formId), submissionID: RouterPath(item.id)).description, style: .ghost(.primary), permission: ContactPermissions.Submissions.read),
                                                    .init("Remove", href: NewAdminLocation.remove(path: ContactAdminRoutes.formSubmissionRemove(formID: RouterPath(item.formId), submissionID: RouterPath(item.id)).description, ids: [item.id], returnTo: returnTo), style: .destructive, permission: ContactPermissions.Submissions.delete),
                                                ], permissions: permissions))
                                            }
                                        }
                                    }
                                }.class("cms-table", "action-table").if(canDelete) { $0.class("select-table") }
                            ))
                        ))
                    }
                },
                search: { context.render(NewAdminListSearch(state: .init(action: path, placeholder: "Quick search contact submissions", search: search))) },
                pagination: { context.render(NewAdminListPagination(state: .init(path: path, pageState: pageState, search: search))) }
            )
        )
    }
}
