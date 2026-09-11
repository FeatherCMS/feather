import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct BlogAuthorLinkDetails: Component {
    struct State {
        let rule: BlogAuthorLinkDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("Blog author link details")
            context.render(AdminDetailsField(label: "ID", value: state.rule.id))
            context.render(
                AdminDetailsField(label: "Label", value: state.rule.label)
            )
            context.render(
                AdminDetailsField(label: "URL", value: state.rule.url)
            )
            context.render(
                AdminDetailsField(
                    label: "Priority",
                    value: "\(state.rule.priority)"
                )
            )
            context.render(
                AdminDetailsField(
                    label: "Blank target",
                    value: state.rule.isBlank ? "Yes" : "No"
                )
            )
            context.render(
                AdminDetailsField(
                    label: "Permission",
                    value: state.rule.permission
                )
            )
            context.render(
                AdminDetailsField(label: "Notes", value: state.rule.notes)
            )
            Div {
                context.render(
                    AdminNavigationButton(
                        "Edit item",
                        href:
                            "/admin/blog/authors/\(state.rule.menuId)/links/\(state.rule.id)/edit/"
                    )
                )
                context.render(
                    AdminNavigationButton(
                        "Remove item",
                        href:
                            "/admin/blog/authors/\(state.rule.menuId)/links/\(state.rule.id)/remove/",
                        classes: ["danger"]
                    )
                )
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
