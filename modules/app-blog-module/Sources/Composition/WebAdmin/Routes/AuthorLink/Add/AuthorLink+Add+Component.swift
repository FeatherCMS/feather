import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink.Add {
    struct Component: WebComponents.Component {
        struct State {
            let authorID: String
            let form: BlogAuthorLinkForm.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: AuthorLink.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Add blog author link",
                            description: "Create a link for this author."
                        )
                    )
                )
                Div {
                    context.build(
                        BlogAuthorLinkForm(
                            state: state.form,
                            action: state.routes
                                .authorLinkAdd(RouterPath(state.authorID))
                                .description,
                            submitLabel: "Add link"
                        )
                    )
                }
            }
            .class("cms-section")
        }
    }
}
