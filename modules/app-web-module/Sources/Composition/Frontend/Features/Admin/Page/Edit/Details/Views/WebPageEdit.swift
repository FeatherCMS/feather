import FeatherAdmin
import FeatherValidation
import FeatherContracts
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebPageEdit: Component {

    struct State {
        let id: String
        let form: WebPageForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))

            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit page",
                        description:
                            "Update the page content and publication settings.",
                        previewHref: previewPath
                    )
                )
            )
            context.build(
                WebPageForm(
                    state: state.form,
                    metadataHref:
                        "/admin/web/pages/\(state.id)/edit/metadata/\(state.id)/",
                    action: "/admin/web/pages/\(state.id)/edit/",
                    submitLabel: "Edit page",
                    removeHref: "/admin/web/pages/\(state.id)/remove/",
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
