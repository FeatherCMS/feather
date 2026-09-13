import FeatherAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct RedirectRuleAddPage: Component {
    let form: RedirectRuleAddForm.State
    let nonceToken: String

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(
                NewAdminBreadcrumb(links: RedirectRuleRoutes.breadcrumb)
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add redirect rule",
                        description:
                            "Create a redirect from one path to another."
                    )
                )
            )
            context.render(
                RedirectRuleAddForm(
                    state: form,
                    action: RedirectRuleRoutes.add.description,
                    nonceToken: nonceToken
                )
            )
        }
        .class("cms-section")
    }
}
