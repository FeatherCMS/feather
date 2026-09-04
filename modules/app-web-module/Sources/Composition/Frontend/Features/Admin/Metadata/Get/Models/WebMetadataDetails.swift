import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct WebMetadataDetails: Leaf {
    struct State {
        let rule: WebMetadataDetailsModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("Web metadata details")
            AdminDetailsField(label: "ID", value: state.rule.id).html()
            AdminDetailsField(
                label: "Reference type",
                value: state.rule.referenceType.isEmpty
                    ? "-" : state.rule.referenceType
            ).html()
            AdminDetailsField(
                label: "Reference ID",
                value: state.rule.referenceId.isEmpty
                    ? "-" : state.rule.referenceId
            ).html()
            AdminDetailsField(label: "Slug", value: state.rule.slug).html()
            AdminDetailsField(
                label: "Status",
                value: state.rule.status.isEmpty ? "-" : state.rule.status
            ).html()
            AdminDetailsField(label: "Title", value: state.rule.title).html()
            AdminDetailsField(
                label: "Publication date",
                value: state.rule.publicationDate.isEmpty
                    ? "-" : state.rule.publicationDate
            ).html()
            AdminDetailsField(
                label: "Expiration date",
                value: state.rule.expirationDate.isEmpty
                    ? "-" : state.rule.expirationDate
            ).html()
            AdminDetailsField(
                label: "Image URL",
                value: state.rule.imageUrl.isEmpty ? "-" : state.rule.imageUrl
            ).html()
            AdminDetailsField(
                label: "Canonical URL",
                value: state.rule.canonicalUrl.isEmpty
                    ? "-" : state.rule.canonicalUrl
            ).html()
            AdminDetailsField(
                label: "No index",
                value: state.rule.noIndex ? "Yes" : "No"
            ).html()
            AdminDetailsField(
                label: "Primary keyword",
                value: state.rule.primaryKeyword.isEmpty
                    ? "-" : state.rule.primaryKeyword
            ).html()
            AdminDetailsField(
                label: "Created",
                value: state.rule.createdAt.isEmpty ? "-" : state.rule.createdAt
            ).html()
            AdminDetailsField(
                label: "Updated",
                value: state.rule.updatedAt.isEmpty ? "-" : state.rule.updatedAt
            ).html()
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

            Div {
                AdminNavigationButton(
                    "Edit web metadata",
                    href: "/admin/web/metadata/\(state.rule.id)/edit/"
                ).html()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
