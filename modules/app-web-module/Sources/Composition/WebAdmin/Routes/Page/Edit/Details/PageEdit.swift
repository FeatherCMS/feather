import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct PageEdit: Component {

    struct State {
        let id: String
        let form: PageForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))

            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Edit page",
                        description:
                            "Update the page content and publication settings.",
                        preview: .init(label: "Preview", href: previewPath)
                    )
                )
            )
            context.build(
                PageForm(
                    state: state.form,
                    metadataHref:
                        PageRoutes.metadata(
                            RouterPath(state.id),
                            RouterPath(state.id)
                        )
                        .description,
                    action: PageRoutes.edit(RouterPath(state.id))
                        .description,
                    submitLabel: "Edit page",
                    removeHref: PageRoutes.details(RouterPath(state.id))
                        .appendingPath(RouterPath("remove")).description,
                    removeLabel: "Remove page"
                )
            )
        }
        .class("cms-section")
    }

    private var previewPath: String? {
        guard let slug = state.form.metadata.slug.value else { return nil }
        let normalizedSlug = slug.whitespaceTrimmed
        return normalizedSlug.isEmpty ? nil : "/\(normalizedSlug)/"
    }
}
