import ContactModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension ContactModule.Form.View {
    struct Page: Component {
        let item: ContactModule.Form.Details.Item
        let permissions: AdminListActions
        let breadcrumb: [AdminBreadcrumb.Link]
        let routes: ContactModule.Form.Router.Routes
        let error: String?

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Contact form details",
                            description:
                                "Review the contact form configuration."
                        )
                    )
                )
                context.build(
                    ContactModule.Form.TabBar(
                        formId: item.key,
                        routes: routes,
                        active: .details
                    )
                )
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Form configuration",
                            description:
                                "Review the form settings and selected fields."
                        )
                    ) {
                        if let error {
                            P(error).class("admin-form__error")
                        }
                        Div {
                            context.build(
                                AdminDetailField(label: "Key", value: item.key)
                            )
                            context.build(
                                AdminDetailField(
                                    label: "Name",
                                    value: item.name
                                )
                                .setAsRemoveConfirmationLabel()
                            )
                            context.build(
                                AdminDetailField(
                                    label: "Success message",
                                    value: item.successMessage.emptyToNil ?? "—"
                                )
                            )
                            context.build(
                                AdminDetailField(
                                    label: "Failure message",
                                    value: item.failureMessage.emptyToNil ?? "—"
                                )
                            )
                            context.build(
                                AdminDetailField(
                                    label: "Redirect URL",
                                    value: item.redirectUrl?.emptyToNil ?? "—"
                                )
                            )
                            context.build(
                                AdminDetailField(
                                    label: "Fields",
                                    value: selectedFieldLabels
                                )
                            )
                            context.build(
                                AdminDetailField(
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
                                    let button = AdminButton(
                                        action.label,
                                        href: action.href,
                                        style: action.style,
                                    )
                                    context.build(button)
                                }
                            }
                            .class("admin-detail-actions")
                            .style(
                                "display:flex;flex-wrap:wrap;gap:12px;margin-top:24px;"
                            )
                        }
                    }
                )
            }
            .class("cms-section")
        }

        private var selectedFieldLabels: String {
            var labels: [String: String] = [:]
            for field in item.availableFields {
                precondition(
                    labels.updateValue(field.label, forKey: field.id) == nil
                )
            }
            let selected = item.selectedFieldIDs.compactMap { labels[$0] }
            return selected.isEmpty ? "—" : selected.joined(separator: ", ")
        }

        private var actions: [AdminDetailView.Action] {
            var result: [AdminDetailView.Action] = []
            if permissions.allows(Form.Permissions.update) {
                result.append(
                    .init(
                        label: "Edit",
                        href: routes.formEditPath(item.key),
                        style: .primary
                    )
                )
            }
            if permissions.allows(Form.Permissions.delete) {
                result.append(
                    .init(
                        label: "Remove",
                        href: AdminLocation.remove(
                            path: routes.formRemove.path,
                            ids: [item.key],
                            returnTo:
                                routes.formDetailsPagePath(item.key)
                        ),
                        style: .destructive,
                    )
                )
            }
            return result
        }
    }
}
