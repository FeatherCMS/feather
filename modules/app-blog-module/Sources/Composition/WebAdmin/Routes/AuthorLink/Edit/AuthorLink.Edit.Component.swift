import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink.Edit {
    struct Component: WebComponents.Component {

        struct State {
            let authorID: String
            let id: String
            let form: AuthorLink.Form.State
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
                            title: "Edit blog author link",
                            description: "Update this author link."
                        )
                    )
                )
                Div {
                    context.build(
                        AuthorLink.Form(
                            state: state.form,
                            action:
                                state.routes
                                .authorLinkEditPath(
                                    state.authorID,
                                    state.id
                                ),
                            submitLabel: "Edit link",
                            removeHref:
                                state.routes
                                .authorLinkRemovePath(
                                    state.authorID
                                ),
                            removeLabel: "Remove link"
                        )
                    )
                }
            }
            .class("cms-section")
        }
    }
}
