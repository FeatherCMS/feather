import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct SystemPermissionDetails: Component {
    struct State {
        let permission: SystemPermissionDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("System permission details")
            context.render(
                AdminDetailsField(label: "ID", value: state.permission.id)
            )
            context.render(
                AdminDetailsField(
                    label: "Name",
                    value: state.permission.name ?? ""
                )
            )
            context.render(
                AdminDetailsField(
                    label: "Notes",
                    value: state.permission.notes ?? ""
                )
            )
            Div {
                context.render(
                    AdminNavigationButton(
                        "Edit permission",
                        href:
                            "/admin/system/permissions/\(state.permission.id)/edit/"
                    )
                )
                context.render(
                    AdminNavigationButton(
                        "Remove permission",
                        href:
                            "/admin/system/permissions/\(state.permission.id)/remove/",
                        classes: ["danger"]
                    )
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
