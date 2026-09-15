import CSS
import FeatherAdmin
import Foundation
import HTML
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

public struct AdminMetadataFields: Component {

    public struct FieldState: FeatherAdmin.Object {
        public var key: String
        public var label: String
        public var value: String?
        public var error: String?

        public init(
            key: String,
            label: String,
            value: String? = nil,
            error: String? = nil
        ) {
            self.key = key
            self.label = label
            self.value = value
            self.error = error
        }
    }

    public struct CheckboxState: FeatherAdmin.Object {
        public var key: String
        public var label: String
        public var value: Bool
        public var error: String?

        public init(
            key: String,
            label: String,
            value: Bool = false,
            error: String? = nil
        ) {
            self.key = key
            self.label = label
            self.value = value
            self.error = error
        }
    }

    public struct State: FeatherAdmin.Object {
        public var slug: FieldState
        public var template: FieldState
        public var slugPrefix: String?
        public var publicationDate: FieldState
        public var expirationDate: FieldState
        public var status: FieldState
        public var title: FieldState
        public var excerpt: FieldState
        public var imageUrl: FieldState
        public var selectedImageAsset: NewAdminMediaAsset?
        public var canonicalUrl: FieldState
        public var noIndex: CheckboxState
        public var primaryKeyword: FieldState
        public var cssCodeInjection: FieldState
        public var javascriptCodeInjection: FieldState
        public var structuredDataCodeInjection: FieldState

        public init(
            slug: FieldState,
            template: FieldState,
            slugPrefix: String? = nil,
            publicationDate: FieldState,
            expirationDate: FieldState,
            status: FieldState,
            title: FieldState,
            excerpt: FieldState,
            imageUrl: FieldState,
            selectedImageAsset: NewAdminMediaAsset? = nil,
            canonicalUrl: FieldState,
            noIndex: CheckboxState,
            primaryKeyword: FieldState,
            cssCodeInjection: FieldState,
            javascriptCodeInjection: FieldState,
            structuredDataCodeInjection: FieldState
        ) {
            self.slug = slug
            self.template = template
            self.slugPrefix = slugPrefix
            self.publicationDate = publicationDate
            self.expirationDate = expirationDate
            self.status = status
            self.title = title
            self.excerpt = excerpt
            self.imageUrl = imageUrl
            self.selectedImageAsset = selectedImageAsset
            self.canonicalUrl = canonicalUrl
            self.noIndex = noIndex
            self.primaryKeyword = primaryKeyword
            self.cssCodeInjection = cssCodeInjection
            self.javascriptCodeInjection = javascriptCodeInjection
            self.structuredDataCodeInjection = structuredDataCodeInjection
        }

        public mutating func apply(errors: [String: String]) {
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

    public let state: State
    public let showTitle: Bool
    public let showTemplate: Bool
    public let titleRequired: Bool
    public let templateOptions: [NewAdminFormFieldSelect.SelectOption]

    public init(
        state: State,
        showTitle: Bool = false,
        showTemplate: Bool = false,
        titleRequired: Bool = false,
        templateOptions: [NewAdminFormFieldSelect.SelectOption] = []
    ) {
        self.state = state
        self.showTitle = showTitle
        self.showTemplate = showTemplate
        self.titleRequired = titleRequired
        self.templateOptions = templateOptions
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("admin-metadata-fields") {
                Display(.grid)
                Gap(20.px)
                MarginTop(32.px)
            },
            Class("admin-metadata-fields__group") {
                Display(.grid)
                Gap(18.px)
            },
            Custom(".admin-metadata-fields > section") {
                Margin(0.px)
            },
        ]
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            context.render(
                NewAdminFormGroup(
                    id: "metadata-configuration",
                    title: "Configuration"
                ) {
                    Div {
                        context.render(
                            NewAdminFormFieldInput(
                                state: .init(
                                    name: state.slug.key,
                                    label: state.slug.label,
                                    value: state.slug.value,
                                    error: state.slug.error,
                                    help: state.slugPrefix,
                                    isRequired: true
                                )
                            )
                        )
                        if showTemplate {
                            context.render(
                                NewAdminFormFieldSelect(
                                    state: .init(
                                        name: state.template.key,
                                        label: state.template.label,
                                        value: state.template.value,
                                        options: [
                                            .init(
                                                label: "Default",
                                                value: "default"
                                            )
                                        ]
                                            + templateOptions.filter {
                                                $0.value != "default"
                                            },
                                        error: state.template.error,
                                        isRequired: true
                                    )
                                )
                            )
                        }
                    }
                    .class("admin-metadata-fields__group")
                }
            )

            context.render(
                NewAdminFormGroup(
                    id: "metadata-publishing",
                    title: "Publishing"
                ) {
                    Div {
                        context.render(
                            NewAdminFormFieldSelect(
                                state: .init(
                                    name: state.status.key,
                                    label: state.status.label,
                                    value: state.status.value,
                                    options: [
                                        "draft", "published", "archived",
                                    ]
                                    .map {
                                        .init(
                                            label: $0.capitalized,
                                            value: $0
                                        )
                                    },
                                    error: state.status.error,
                                    isRequired: true
                                )
                            )
                        )
                        context.render(
                            NewAdminFormFieldDatePicker(
                                state: .init(
                                    name: state.publicationDate.key,
                                    label: state.publicationDate.label,
                                    value: state.publicationDate.value,
                                    error: state.publicationDate.error,
                                    id: state.publicationDate.key
                                )
                            )
                        )
                        context.render(
                            NewAdminFormFieldDatePicker(
                                state: .init(
                                    name: state.expirationDate.key,
                                    label: state.expirationDate.label,
                                    value: state.expirationDate.value,
                                    error: state.expirationDate.error,
                                    id: state.expirationDate.key
                                )
                            )
                        )
                    }
                    .class("admin-metadata-fields__group")
                }
            )

            context.render(
                NewAdminFormGroup(
                    id: "metadata-metadata",
                    title: "Meta tags"
                ) {
                    Div {
                        imagePicker(
                            state.imageUrl,
                            selectedAsset: state.selectedImageAsset,
                            context: &context
                        )
                        if showTitle {
                            context.render(
                                NewAdminFormFieldInput(
                                    state: .init(
                                        name: state.title.key,
                                        label: state.title.label,
                                        value: state.title.value,
                                        error: state.title.error,
                                        isRequired: titleRequired
                                    )
                                )
                            )
                        }
                        context.render(
                            NewAdminFormFieldTextArea(
                                state: .init(
                                    name: state.excerpt.key,
                                    label: state.excerpt.label,
                                    value: state.excerpt.value,
                                    error: state.excerpt.error,
                                    style: .small
                                )
                            )
                        )
                    }
                    .class("admin-metadata-fields__group")
                }
            )

            context.render(
                NewAdminFormGroup(
                    id: "metadata-seo",
                    title: "SEO"
                ) {
                    Div {
                        context.render(
                            NewAdminFormFieldInput(
                                state: .init(
                                    name: state.canonicalUrl.key,
                                    label: state.canonicalUrl.label,
                                    value: state.canonicalUrl.value,
                                    error: state.canonicalUrl.error
                                )
                            )
                        )
                        context.render(
                            NewAdminFormFieldCheckbox(
                                state: .init(
                                    name: state.noIndex.key,
                                    label: "Search engine indexing",
                                    checkboxLabel:
                                        "Disallow indexing for this page",
                                    isChecked: state.noIndex.value,
                                    error: state.noIndex.error
                                )
                            )
                        )
                        context.render(
                            NewAdminFormFieldInput(
                                state: .init(
                                    name: state.primaryKeyword.key,
                                    label: state.primaryKeyword.label,
                                    value: state.primaryKeyword.value,
                                    error: state.primaryKeyword.error
                                )
                            )
                        )
                    }
                    .class("admin-metadata-fields__group")
                }
            )

            context.render(
                NewAdminFormGroup(
                    id: "metadata-advanced",
                    title: "Advanced"
                ) {
                    Div {
                        context.render(
                            NewAdminFormFieldTextArea(
                                state: .init(
                                    name: state.cssCodeInjection.key,
                                    label: state.cssCodeInjection.label,
                                    value: state.cssCodeInjection.value,
                                    error: state.cssCodeInjection.error,
                                    style: .large
                                )
                            )
                        )
                        context.render(
                            NewAdminFormFieldTextArea(
                                state: .init(
                                    name: state.javascriptCodeInjection.key,
                                    label: state.javascriptCodeInjection.label,
                                    value: state.javascriptCodeInjection.value,
                                    error: state.javascriptCodeInjection.error,
                                    style: .large
                                )
                            )
                        )
                        context.render(
                            NewAdminFormFieldTextArea(
                                state: .init(
                                    name: state.structuredDataCodeInjection.key,
                                    label: state.structuredDataCodeInjection
                                        .label,
                                    value: state.structuredDataCodeInjection
                                        .value,
                                    error:
                                        state.structuredDataCodeInjection.error,
                                    style: .large
                                )
                            )
                        )
                    }
                    .class("admin-metadata-fields__group")
                }
            )
        }
        .class("admin-metadata-fields")
    }

    private func imagePicker(
        _ field: FieldState,
        selectedAsset: NewAdminMediaAsset?,
        context: inout RenderContext
    ) -> Section {
        let browsePath =
            "/admin/media/assets/?picker=1&field=\(field.key.queryEncoded())&extensions=png,jpg,jpeg,webp"
        return context.render(
            NewAdminFormFieldMediaPicker(
                state: .init(
                    field: .init(
                        key: field.key,
                        label: field.label,
                        value: field.value,
                        error: field.error
                    ),
                    selectedAsset: selectedAsset.map {
                        .init(
                            id: $0.id,
                            storageKey: $0.storageKey,
                            baseName: $0.baseName,
                            type: $0.type,
                            title: $0.title,
                            altText: $0.altText,
                            status: $0.status
                        )
                    },
                    browsePath: browsePath,
                    allowedExtensions: ["png", "jpg", "jpeg", "webp"],
                    outputMode: .originalURL
                )
            )
        )
    }
}
