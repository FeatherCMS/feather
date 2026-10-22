import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents

import protocol SGML.BasicTag

extension Author.Edit {
    struct Component: WebComponents.Component {
        struct State {
            let id: String
            let form: BlogAuthorForm.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Author.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit author",
                            description: "Update this blog author."
                        )
                    )
                )
                context.build(
                    BlogAuthorForm(
                        state: state.form,
                        metadataHref: state.routes
                            .authorEditMetadata(
                                RouterPath(state.id),
                                RouterPath(state.id)
                            )
                            .description,
                        action: state.routes.authorEdit(RouterPath(state.id))
                            .description,
                        submitLabel: "Edit author",
                        removeHref: state.routes
                            .authorRemove(RouterPath(state.id))
                            .description,
                        removeLabel: "Remove author"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
