import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents

import protocol SGML.BasicTag

extension Tag.Edit {
    struct Component: WebComponents.Component {
        struct State {
            let id: String
            let form: BlogTagForm.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: BlogWebAdmin.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit tag",
                            description: "Update this blog tag."
                        )
                    )
                )
                context.build(
                    BlogTagForm(
                        state: state.form,
                        metadataHref: state.routes
                            .tagEditMetadata(
                                RouterPath(state.id),
                                RouterPath(state.id)
                            )
                            .description,
                        action: state.routes.tagEdit(RouterPath(state.id))
                            .description,
                        submitLabel: "Edit tag",
                        removeHref: state.routes
                            .tagRemove(RouterPath(state.id))
                            .description,
                        removeLabel: "Remove tag"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
