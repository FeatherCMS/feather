import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct WebMetadataDetails: Component {
    struct State {
        let rule: WebMetadataDetailsModel
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminDetailView(
                    breadcrumb: state.breadcrumb,
                    pageHeader: .init(
                        title: "Web metadata details",
                        description: "Review the metadata configuration."
                    ),
                    fields: [
                        .init(label: "ID", value: state.rule.id),
                        .init(
                            label: "Reference type",
                            value: state.rule.referenceType.isEmpty
                                ? "—" : state.rule.referenceType
                        ),
                        .init(
                            label: "Reference ID",
                            value: state.rule.referenceId.isEmpty
                                ? "—" : state.rule.referenceId
                        ),
                        .init(label: "Slug", value: state.rule.slug),
                        .init(
                            label: "Status",
                            value: state.rule.status.isEmpty
                                ? "—" : state.rule.status
                        ),
                        .init(label: "Title", value: state.rule.title),
                        .init(
                            label: "Publication date",
                            value: state.rule.publicationDate.isEmpty
                                ? "—" : state.rule.publicationDate
                        ),
                        .init(
                            label: "Expiration date",
                            value: state.rule.expirationDate.isEmpty
                                ? "—" : state.rule.expirationDate
                        ),
                        .init(
                            label: "Image URL",
                            value: state.rule.imageUrl.isEmpty
                                ? "—" : state.rule.imageUrl
                        ),
                        .init(
                            label: "Canonical URL",
                            value: state.rule.canonicalUrl.isEmpty
                                ? "—" : state.rule.canonicalUrl
                        ),
                        .init(
                            label: "No index",
                            value: state.rule.noIndex ? "Yes" : "No"
                        ),
                        .init(
                            label: "Primary keyword",
                            value: state.rule.primaryKeyword.isEmpty
                                ? "—" : state.rule.primaryKeyword
                        ),
                        .init(
                            label: "Created",
                            value: state.rule.createdAt.isEmpty
                                ? "—" : state.rule.createdAt
                        ),
                        .init(
                            label: "Updated",
                            value: state.rule.updatedAt.isEmpty
                                ? "—" : state.rule.updatedAt
                        ),
                    ],
                    actions: [
                        .init(
                            label: "Edit web metadata",
                            href:
                                WebMetadataRoutes.edit(
                                    RouterPath(state.rule.id)
                                )
                                .description,
                            style: .primary
                        )
                    ]
                )
            )
            Section {
                H2("Excerpt")
                if state.rule.excerpt.isEmpty {
                    P("-")
                }
                else {
                    Pre(state.rule.excerpt)
                }
            }
            Section {
                H2("CSS code injection")
                if state.rule.cssCodeInjection.isEmpty {
                    P("-")
                }
                else {
                    Pre(state.rule.cssCodeInjection)
                }
            }
            Section {
                H2("JavaScript code injection")
                if state.rule.javascriptCodeInjection.isEmpty {
                    P("-")
                }
                else {
                    Pre(state.rule.javascriptCodeInjection)
                }
            }
            Section {
                H2("Structured data")
                if state.rule.structuredDataCodeInjection.isEmpty {
                    P("-")
                }
                else {
                    Pre(state.rule.structuredDataCodeInjection)
                }
            }

        }
        .class("cms-section")
    }
}
