import FeatherAdmin
import HTML
import Hummingbird
import RedirectContracts
import WebBuilders
import WebComponents

struct RedirectRuleEditPage: Component {
    let id: String
    let form: RedirectRuleEditForm.State
    let nonceToken: String
    let permissions: NewAdminListActions

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(
                NewAdminBreadcrumb(links: RedirectRuleRoutes.breadcrumb)
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit redirect rule",
                        description: "Update the redirect rule configuration."
                    )
                )
            )
            context.render(
                RedirectRuleEditForm(
                    state: form,
                    action: RedirectRuleRoutes.edit(RouterPath(id)).description,
                    viewHref: permissions.allows(RedirectPermissions.Rules.read)
                        ? RedirectRuleRoutes.details(RouterPath(id)).description
                        : nil,
                    removeHref: permissions.allows(
                        RedirectPermissions.Rules.delete
                    )
                        ? RedirectRuleRoutes.remove(RouterPath(id)).description
                        : nil,
                    nonceToken: nonceToken
                )
            )
        }
        .class("cms-section")
    }
}
