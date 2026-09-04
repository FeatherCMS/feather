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

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Web metadata details")
            AdminDetailsField(label: "ID", value: state.rule.id).renderHTML()
            AdminDetailsField(
                label: "Reference type",
                value: state.rule.referenceType.isEmpty
                    ? "-" : state.rule.referenceType
            ).renderHTML()
            AdminDetailsField(
                label: "Reference ID",
                value: state.rule.referenceId.isEmpty
                    ? "-" : state.rule.referenceId
            ).renderHTML()
            AdminDetailsField(label: "Slug", value: state.rule.slug).renderHTML()
            AdminDetailsField(
                label: "Status",
                value: state.rule.status.isEmpty ? "-" : state.rule.status
            ).renderHTML()
            AdminDetailsField(label: "Title", value: state.rule.title).renderHTML()
            AdminDetailsField(
                label: "Publication date",
                value: state.rule.publicationDate.isEmpty
                    ? "-" : state.rule.publicationDate
            ).renderHTML()
            AdminDetailsField(
                label: "Expiration date",
                value: state.rule.expirationDate.isEmpty
                    ? "-" : state.rule.expirationDate
            ).renderHTML()
            AdminDetailsField(
                label: "Image URL",
                value: state.rule.imageUrl.isEmpty ? "-" : state.rule.imageUrl
            ).renderHTML()
            AdminDetailsField(
                label: "Canonical URL",
                value: state.rule.canonicalUrl.isEmpty
                    ? "-" : state.rule.canonicalUrl
            ).renderHTML()
            AdminDetailsField(
                label: "No index",
                value: state.rule.noIndex ? "Yes" : "No"
            ).renderHTML()
            AdminDetailsField(
                label: "Primary keyword",
                value: state.rule.primaryKeyword.isEmpty
                    ? "-" : state.rule.primaryKeyword
            ).renderHTML()
            AdminDetailsField(
                label: "Created",
                value: state.rule.createdAt.isEmpty ? "-" : state.rule.createdAt
            ).renderHTML()
            AdminDetailsField(
                label: "Updated",
                value: state.rule.updatedAt.isEmpty ? "-" : state.rule.updatedAt
            ).renderHTML()
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
                ).renderHTML()
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
