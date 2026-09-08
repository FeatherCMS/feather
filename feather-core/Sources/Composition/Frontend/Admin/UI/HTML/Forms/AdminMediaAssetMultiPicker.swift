import CSS
import Foundation
import HTML
import SGML
import WebStandards

public struct AdminMediaAssetMultiPicker: Component, FlowContent {
    public struct FieldState: Sendable {
        public let key: String
        public let label: String
        public let values: [String]
        public let error: String?

        public init(
            key: String,
            label: String,
            values: [String],
            error: String?
        ) {
            self.key = key
            self.label = label
            self.values = values
            self.error = error
        }
    }

    public struct State: Sendable {
        public let field: FieldState
        public let selectedAssets: [AdminMediaAssetReferenceModel]
        public let browsePath: String
        public let allowedExtensions: [String]

        public init(
            field: FieldState,
            selectedAssets: [AdminMediaAssetReferenceModel] = [],
            browsePath: String,
            allowedExtensions: [String]
        ) {
            self.field = field
            self.selectedAssets = selectedAssets
            self.browsePath = browsePath
            self.allowedExtensions = allowedExtensions
        }
    }

    public let state: State

    public init(
        state: State
    ) {
        self.state = state
    }

    public func selectors(
        // empty
    ) -> [any CSS.Selector] {
        Class("admin-media-asset-multi-picker") {
            Display(.grid)
            Gap(12.px)
        }
        Class("admin-media-asset-multi-picker__values") {
            Display(.grid)
            Gap(8.px)
        }
        Class("admin-media-asset-multi-picker__item") {
            Display(.flex)
            AlignItems(.center)
            JustifyContent(.spaceBetween)
            Gap(12.px)
            Padding(10.px)
            Border(1.px, .solid, .variable("cms-gray-2"))
            BorderRadius(10.px)
            Background(color: .color(.variable("cms-white")))
        }
        Class("admin-media-asset-multi-picker__details") {
            MinWidth(0.px)
            Display(.grid)
            Gap(2.px)
        }
        Class("admin-media-asset-multi-picker__name") {
            Color(.variable("cms-strong-font"))
            UnsafeRawProperty(name: "overflow-wrap", value: "anywhere")
        }
        Class("admin-media-asset-multi-picker__id") {
            Color(.variable("cms-light-font"))
            FontSize(12.px)
            UnsafeRawProperty(name: "overflow-wrap", value: "anywhere")
        }
        Class("admin-media-asset-picker-modal") {
            Position(.fixed)
            UnsafeRawProperty(name: "inset", value: "0")
            Display(.none)
            AlignItems(.center)
            JustifyContent(.center)
            Padding(24.px)
            UnsafeRawProperty(name: "background", value: "rgb(15 23 42 / 0.68)")
            ZIndex(.number(2000))
        }
        Class("admin-media-asset-picker-modal-visible") {
            Display(.flex)
        }
        Class("admin-media-asset-picker-dialog") {
            UnsafeRawProperty(
                name: "width",
                value: "min(1200px, calc(100vw - 48px))"
            )
            UnsafeRawProperty(
                name: "height",
                value: "min(820px, calc(100vh - 48px))"
            )
            Display(.grid)
            UnsafeRawProperty(
                name: "grid-template-rows",
                value: "auto auto minmax(0, 1fr)"
            )
            Gap(12.px)
            Padding(18.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(20.px)
            Background(color: .color(.variable("cms-white")))
        }
        Class("admin-media-asset-picker-dialog-header") {
            Display(.flex)
            AlignItems(.center)
            JustifyContent(.spaceBetween)
            Gap(12.px)
        }
        Class("admin-media-asset-picker-tabs") {
            Display(.flex)
            AlignItems(.center)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(999.px)
            MarginBottom(8.px)
            Padding(4.px)
            Gap(4.px)
            Width(100.percent)
        }
        Custom(".admin-media-asset-picker-tabs button") {
            Flex(1)
            Border(0)
            BorderRadius(999.px)
            Background(color: .transparent)
            Color(.variable("cms-light-font"))
            Padding(vertical: 8.px, horizontal: 12.px)
            LineHeight(1.2)
            TextAlign(.center)
            UnsafeRawProperty(name: "cursor", value: "pointer")
        }
        Custom(".admin-media-asset-picker-tabs button:hover:not(.is-current)") {
            Color(.variable("cms-link-hover"))
            TextDecoration(.underline)
        }
        Custom(".admin-media-asset-picker-tabs button.is-current") {
            UnsafeRawProperty(name: "background", value: "var(--cms-gray-4)")
            Color(.variable("cms-strong-font"))
        }
        Class("admin-media-asset-picker-panel") {
            MinHeight(0.px)
            Overflow(.auto)
            Padding(vertical: 0.px, horizontal: 4.px)
        }
        Class("admin-media-asset-picker-loading") {
            Display(.grid)
            UnsafeRawProperty(name: "place-items", value: "center")
            MinHeight(180.px)
            Color(.variable("cms-light-font"))
        }
    }

    public func content(
        // empty
    ) -> some BasicTag {
        Section {
            Label {
                Span(state.field.label).class("field-label")
            }
            .for(state.field.key)

            Div {
                for value in state.field.values {
                    item(
                        id: value,
                        asset: state.selectedAssets.first(where: {
                            $0.id == value
                        })
                    )
                }
            }
            .data("media-picker-values", state.field.key)
            .class("admin-media-asset-multi-picker__values")

            Button("Upload or choose documents")
                .type(.button)
                .class("secondary")
                .data("media-picker-open", state.field.key)

            if let error = state.field.error {
                Span(error).class("field-error")
            }

            modal()
        }
        .if(state.field.error != nil) { $0.class("has-error") }
        .class("admin-media-asset-multi-picker")
    }

    private func item(
        id: String,
        asset: AdminMediaAssetReferenceModel?
    ) -> some FlowContent {
        Div {
            Div {
                Span(asset.map(assetName) ?? "Missing document")
                    .class("admin-media-asset-multi-picker__name")
                if asset == nil {
                    Span(id).class("admin-media-asset-multi-picker__id")
                }
            }
            .class("admin-media-asset-multi-picker__details")

            Button("Remove")
                .type(.button)
                .class("ghost")
                .data("media-picker-remove", id)

            Input()
                .type(.hidden)
                .name("\(state.field.key)[]")
                .value(id)
        }
        .data("media-picker-value", id)
        .class("admin-media-asset-multi-picker__item")
    }

    private func modal(
        // empty
    ) -> some FlowContent {
        let helperText = state.allowedExtensions.isEmpty
            ? "Browse folders, search assets, or upload a new item."
            : "Allowed types: \(state.allowedExtensions.joined(separator: ", "))."
        return Div {
            Div {
                Div {
                    Div {
                        H3(state.field.label)
                        P(helperText)
                    }
                    Button("Close")
                        .type(.button)
                        .class("ghost")
                        .data("media-picker-close", state.field.key)
                }
                .class("admin-media-asset-picker-dialog-header")

                Div {
                    Button("Gallery")
                        .type(.button)
                        .class("is-current")
                        .data("media-picker-tab", "gallery")
                        .data("media-picker-field", state.field.key)
                    Button("Upload")
                        .type(.button)
                        .data("media-picker-tab", "upload")
                        .data("media-picker-field", state.field.key)
                }
                .class("admin-media-asset-picker-tabs")

                Style("").data("media-picker-style", state.field.key)
                Div {
                    P("Loading...")
                }
                .class("admin-media-asset-picker-loading")
                .class("admin-media-asset-picker-panel")
                .data("media-picker-panel", state.field.key)
            }
            .class("admin-media-asset-picker-dialog")

            Script(AdminMediaAssetPicker.pickerScript())
        }
        .id("mediaPickerModal-\(state.field.key)")
        .class("admin-media-asset-picker-modal")
        .data("media-picker-browse-path", state.browsePath)
        .data("media-picker-upload-path", uploadPath())
        .data("media-picker-active-tab", "gallery")
        .data("media-picker-selection", "multiple")
    }

    private func assetName(
        _ asset: AdminMediaAssetReferenceModel
    ) -> String {
        asset.type.isEmpty ? asset.baseName : "\(asset.baseName).\(asset.type)"
    }

    private func uploadPath(
        // empty
    ) -> String {
        state.browsePath.hasPrefix("/admin/media/assets/add/")
            ? state.browsePath
            : state.browsePath.replacingOccurrences(
                of: "/admin/media/assets/",
                with: "/admin/media/assets/add/"
            )
    }
}
