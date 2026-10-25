import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

extension Campaign.Edit {
    struct View: Component {
        struct State {
            let id: String
            let routes: Campaign.Router.Routes
            let form: Campaign.Form.Component.State
            let isDetails: Bool
            let permissions: AdminListActions
            let pageHeader: AdminPageHeader.State
        }
        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            let editPath = state.routes.editPath(state.id)
            return Section {
                context.build(
                    AdminBreadcrumb(
                        links: state.routes.breadcrumb + [
                            .init(
                                label: "Campaigns",
                                link: state.routes.list.path
                            )
                        ]
                    )
                )
                context.build(
                    AdminPageHeader(
                        state: state.pageHeader.addingActions(
                            state.permissions.allows(
                                Campaign.Permissions.delete
                            )
                                ? [
                                    .init(
                                        label: "Remove campaign",
                                        href: AdminLocation.remove(
                                            path: state.routes.removeSelected
                                                .path,
                                            ids: [state.id],
                                            returnTo: state.routes.detailsPath(
                                                state.id
                                            )
                                        ),
                                        style: .destructive
                                    )
                                ]
                                : []
                        )
                    )
                )
                context.build(
                    Campaign.Tabs(
                        id: state.id,
                        active: .details,
                        routes: state.routes
                    )
                )
                if state.isDetails {
                    context.build(
                        AdminRelationshipGroup(
                            pageHeader: .secondary(
                                title: "Campaign details",
                                description:
                                    "Review the campaign configuration."
                            )
                        ) {
                            Div {
                                context.build(
                                    AdminDetailField(
                                        label: "Key",
                                        value: state.form.key
                                    )
                                )
                                context.build(
                                    AdminDetailField(
                                        label: "Name",
                                        value: state.form.name
                                    )
                                    .setAsRemoveConfirmationLabel()
                                )
                                context.build(
                                    AdminDetailField(
                                        label: "From email",
                                        value: state.form.fromEmail
                                    )
                                )
                            }
                            .class("admin-detail-view-fields")
                            .style("display:grid;gap:12px;")
                            Div {
                                if state.permissions.allows(
                                    Campaign.Permissions.update
                                ) {
                                    context.build(
                                        AdminButton(
                                            "Edit",
                                            href: editPath,
                                            style: .primary
                                        )
                                    )
                                }
                            }
                            .class("admin-detail-actions")
                            .style(
                                "display:flex;flex-wrap:wrap;gap:12px;margin-top:24px;"
                            )
                        }
                    )
                }
                else {
                    context.build(
                        AdminRelationshipGroup(
                            pageHeader: .secondary(
                                title: "Campaign configuration",
                                description:
                                    "Update the campaign key, name, and sender address."
                            )
                        ) {
                            context.build(
                                Campaign.Form.Component(
                                    state: state.form,
                                    action: editPath,
                                    submitLabel: "Save campaign"
                                )
                            )
                        }
                    )
                }
            }
            .class("cms-section")
        }
    }
}
