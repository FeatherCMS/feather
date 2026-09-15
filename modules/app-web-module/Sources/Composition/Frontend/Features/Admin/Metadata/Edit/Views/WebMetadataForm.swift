import FeatherAdmin
import Foundation
import HTML
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct WebMetadataForm: Component {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct CheckboxState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: Bool
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var referenceType: FieldState?
        var referenceId: FieldState?
        var slug: FieldState
        var template: FieldState
        var templateOptions: [WebPageTemplateOption]
        var publicationDate: FieldState
        var expirationDate: FieldState
        var status: FieldState
        var title: FieldState
        var excerpt: FieldState
        var imageUrl: FieldState
        var selectedImageAsset: NewAdminMediaAsset?
        var canonicalUrl: FieldState
        var noIndex: CheckboxState
        var primaryKeyword: FieldState
        var cssCodeInjection: FieldState
        var javascriptCodeInjection: FieldState
        var structuredDataCodeInjection: FieldState
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            slug.error = errors[slug.key]
            template.error = errors[template.key]
            publicationDate.error = errors[publicationDate.key]
            expirationDate.error = errors[expirationDate.key]
            status.error = errors[status.key]
            title.error = errors[title.key]
            excerpt.error = errors[excerpt.key]
            imageUrl.error = errors[imageUrl.key]
            canonicalUrl.error = errors[canonicalUrl.key]
            noIndex.error = errors[noIndex.key]
            primaryKeyword.error = errors[primaryKeyword.key]
            cssCodeInjection.error = errors[cssCodeInjection.key]
            javascriptCodeInjection.error = errors[javascriptCodeInjection.key]
            structuredDataCodeInjection.error =
                errors[structuredDataCodeInjection.key]
        }
    }

    var state: State
    var action: String
    var submitLabel: String
    var removeHref: String? = nil
    var removeLabel: String = "Remove"

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action) {
            if let success = state.success {
                P(success).class("new-admin-form__success")
            }
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }

            context.render(
                AdminMetadataFields(
                    state: .init(
                        slug: .init(
                            key: state.slug.key,
                            label: state.slug.label,
                            value: state.slug.value,
                            error: state.slug.error
                        ),
                        template: .init(
                            key: state.template.key,
                            label: state.template.label,
                            value: state.template.value,
                            error: state.template.error
                        ),
                        publicationDate: .init(
                            key: state.publicationDate.key,
                            label: state.publicationDate.label,
                            value: state.publicationDate.value,
                            error: state.publicationDate.error
                        ),
                        expirationDate: .init(
                            key: state.expirationDate.key,
                            label: state.expirationDate.label,
                            value: state.expirationDate.value,
                            error: state.expirationDate.error
                        ),
                        status: .init(
                            key: state.status.key,
                            label: state.status.label,
                            value: state.status.value,
                            error: state.status.error
                        ),
                        title: .init(
                            key: state.title.key,
                            label: state.title.label,
                            value: state.title.value,
                            error: state.title.error
                        ),
                        excerpt: .init(
                            key: state.excerpt.key,
                            label: state.excerpt.label,
                            value: state.excerpt.value,
                            error: state.excerpt.error
                        ),
                        imageUrl: .init(
                            key: state.imageUrl.key,
                            label: state.imageUrl.label,
                            value: state.imageUrl.value,
                            error: state.imageUrl.error
                        ),
                        selectedImageAsset: state.selectedImageAsset,
                        canonicalUrl: .init(
                            key: state.canonicalUrl.key,
                            label: state.canonicalUrl.label,
                            value: state.canonicalUrl.value,
                            error: state.canonicalUrl.error
                        ),
                        noIndex: .init(
                            key: state.noIndex.key,
                            label: state.noIndex.label,
                            value: state.noIndex.value,
                            error: state.noIndex.error
                        ),
                        primaryKeyword: .init(
                            key: state.primaryKeyword.key,
                            label: state.primaryKeyword.label,
                            value: state.primaryKeyword.value,
                            error: state.primaryKeyword.error
                        ),
                        cssCodeInjection: .init(
                            key: state.cssCodeInjection.key,
                            label: state.cssCodeInjection.label,
                            value: state.cssCodeInjection.value,
                            error: state.cssCodeInjection.error
                        ),
                        javascriptCodeInjection: .init(
                            key: state.javascriptCodeInjection.key,
                            label: state.javascriptCodeInjection.label,
                            value: state.javascriptCodeInjection.value,
                            error: state.javascriptCodeInjection.error
                        ),
                        structuredDataCodeInjection: .init(
                            key: state.structuredDataCodeInjection.key,
                            label: state.structuredDataCodeInjection.label,
                            value: state.structuredDataCodeInjection.value,
                            error: state.structuredDataCodeInjection.error
                        )
                    ),
                    showTitle: true,
                    showTemplate: true,
                    templateOptions: state.templateOptions.map {
                        .init(label: $0.title, value: $0.value)
                    }
                )
            )

            Section {
                Div {
                    context.render(NewAdminSubmitButton(submitLabel))
                    if let removeHref {
                        context.render(
                            NewAdminButton(
                                removeLabel,
                                href: removeHref,
                                style: .destructive
                            )
                        )
                    }
                }
                .class("new-admin-form__actions")
            }
        }
        return context.render(form)
    }

}
