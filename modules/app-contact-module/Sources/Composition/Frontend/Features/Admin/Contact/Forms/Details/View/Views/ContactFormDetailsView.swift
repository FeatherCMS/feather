import ContactContracts
import FeatherAdmin
import FeatherContracts
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

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: breadcrumb))
            context.build(
                AdminContactFormHeader(formId: item.key, active: .details)
            )
            if let error {
                P(error).class("new-admin-form__error")
            }
            H2("Contact form details")
            Div {
                context.build(NewAdminDetailField(label: "Key", value: item.key))
                context.build(NewAdminDetailField(label: "Name", value: item.name))
                context.build(
                    NewAdminDetailField(
                        label: "Success message",
                        value: item.successMessage.emptyToNil ?? "—"
                    )
                )
                context.build(
                    NewAdminDetailField(
                        label: "Failure message",
                        value: item.failureMessage.emptyToNil ?? "—"
                    )
                )
                context.build(
                    NewAdminDetailField(
                        label: "Redirect URL",
                        value: item.redirectUrl?.emptyToNil ?? "—"
                    )
                )
                context.build(
                    NewAdminDetailField(label: "Fields", value: selectedFieldLabels)
                )
                context.build(
                    NewAdminDetailField(
                        label: "Email definitions",
                        value: "\(item.mails.count)"
                    )
                )
            }
            .class("admin-detail-view-fields")
            .style("display:grid;gap:12px;")
            if !actions.isEmpty {
                Div {
                    for action in actions {
                        context.build(
                            NewAdminButton(
                                action.label,
                                href: action.href,
                                style: action.style
                            )
                        )
                    }
                }
                .class("new-admin-detail-actions")
                .style("display:flex;flex-wrap:wrap;gap:12px;margin-top:24px;")
            }
        }
        .class("cms-section")
    }

    private var selectedFieldLabels: String {
        let labels = Dictionary(
            uniqueKeysWithValues: item.availableFields.map { ($0.id, $0.label) }
        )
        let selected = item.selectedFieldIDs.compactMap { labels[$0] }
        return selected.isEmpty ? "—" : selected.joined(separator: ", ")
    }

    private var actions: [NewAdminDetailView.Action] {
        var result: [NewAdminDetailView.Action] = []
        if permissions.allows(ContactPermissions.Forms.update) {
            result.append(
                .init(
                    label: "Edit",
                    href: ContactAdminRoutes.formEdit(RouterPath(item.key))
                        .description,
                    style: .primary
                )
            )
        }
        if permissions.allows(ContactPermissions.Forms.delete) {
            result.append(
                .init(
                    label: "Remove",
                    href: NewAdminLocation.remove(
                        path: ContactAdminRoutes.formRemove.description,
                        ids: [item.key],
                        returnTo:
                            ContactAdminRoutes.formDetails(RouterPath(item.key))
                            .description
                    ),
                    style: .destructive
                )
            )
        }
        return result
    }
}
