import FeatherWebAdmin
import HTML
import Hummingbird
import RedirectModule
import WebBuilders
import WebComponents

struct RedirectRuleEditPage: Component {
    let id: String
    let form: RedirectRuleEditForm.State
    let nonceToken: String
    let permissions: AdminListActions
    let routes: Rule.Router.Routes

    func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(
                AdminBreadcrumb(links: routes.breadcrumb)
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Edit redirect rule",
                        description: "Update the redirect rule configuration."
                    )
                )
            )
            context.build(
                RedirectRuleEditForm(
                    state: form,
                    action: routes.editPath(id),
                    viewHref: permissions.allows(Rule.Permissions.read)
                        ? routes.detailsPath(id)
                        : nil,
                    removeHref: permissions.allows(
                        Rule.Permissions.delete
                    )
                        ? routes.removePath(id)
                        : nil,
                    nonceToken: nonceToken
                )
            )
        }
        .class("cms-section")
    }
}
