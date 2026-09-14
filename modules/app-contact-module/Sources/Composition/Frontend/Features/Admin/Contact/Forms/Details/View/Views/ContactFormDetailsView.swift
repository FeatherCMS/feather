import FeatherAdmin
import FeatherContracts
import ContactContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormDetailsView: Component {
    let item: AdminContactFormDetailsItem
    let permissions: NewAdminListActions
    let breadcrumb: [NewAdminBreadcrumb.Link]
    let error: String?

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            if let error {
                P(error).class("new-admin-form__error")
            }
            context.render(
                NewAdminDetailView(
                    breadcrumb: breadcrumb,
                    pageHeader: .init(
                        title: "Contact form details",
                        description: "Review the contact form configuration."
                    ),
                    fields: [
                        .init(label: "Name", value: item.name),
                        .init(label: "Success message", value: item.successMessage.emptyToNil ?? "—"),
                        .init(label: "Failure message", value: item.failureMessage.emptyToNil ?? "—"),
                        .init(label: "Redirect URL", value: item.redirectUrl?.emptyToNil ?? "—"),
                        .init(label: "Fields", value: selectedFieldLabels),
                        .init(label: "Email definitions", value: "\(item.mails.count)"),
                    ],
                    actions: actions
                )
            )
        }
        .class("cms-section")
    }

    private var selectedFieldLabels: String {
        let labels = Dictionary(uniqueKeysWithValues: item.availableFields.map { ($0.id, $0.label) })
        let selected = item.selectedFieldIDs.compactMap { labels[$0] }
        return selected.isEmpty ? "—" : selected.joined(separator: ", ")
    }

    private var actions: [NewAdminDetailView.Action] {
        var result: [NewAdminDetailView.Action] = []
        if permissions.allows(ContactPermissions.Forms.update) {
            result.append(.init(label: "Edit", href: ContactAdminRoutes.formEdit(RouterPath(item.id)).description, style: .primary))
        }
        if permissions.allows(ContactPermissions.Forms.delete) {
            result.append(.init(label: "Remove", href: NewAdminLocation.remove(path: ContactAdminRoutes.formRemove.description, ids: [item.id], returnTo: ContactAdminRoutes.formDetails(RouterPath(item.id)).description), style: .destructive))
        }
        return result
    }
}
