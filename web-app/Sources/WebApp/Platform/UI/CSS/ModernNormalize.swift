//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 07..
//

import CSS
import WebStandards

extension CSS {

    struct ModernNormalize: GlobalStyleComponent {

        static func selectors() -> [any Selector] {
            Custom("*,::before,::after") {
                BoxSizing(.borderBox)
            }
            Custom("html") {
                FontFamily(
                    "system-ui",
                    "'Segoe UI'",
                    "Roboto",
                    "Helvetica",
                    "Arial",
                    "sans-serif",
                    "Apple Color Emoji",
                    "Segoe UI Emoji",
                )
                LineHeight(1.15)
                UnsafeRawProperty(
                    name: "-webkit-text-size-adjust",
                    value: "100%"
                )
                UnsafeRawProperty(name: "-moz-tab-size", value: "4")
                TabSize(4)
            }
            Custom("body") {
                Margin(0)
            }
            Custom("hr") {
                Height(0)
                Color(.inherit)
            }
            Custom("abbr[title]") {
                TextDecoration(.underline, nil, .dotted)
            }
            Custom("b,strong") {
                FontWeight(.bolder)
            }
            Custom("code,kbd,samp,pre") {
                FontFamily(
                    "ui-monospace",
                    "SFMono-Regular",
                    "Consolas",
                    "'Liberation Mono'",
                    "Menlo",
                    "monospace",
                )
                FontSize(1.em)
            }
            Custom("small") {
                FontSize(80.percent)
            }
            Custom("sub,sup") {
                FontSize(75.percent)
                LineHeight(0)
                Position(.relative)
                VerticalAlign(.baseline)
            }
            Custom("sub") {
                Bottom((-0.25).em)
            }
            Custom("sup") {
                Top((-0.5).em)
            }
            Custom("table") {
                TextIndent(0)
                BorderColor(.inherit)
            }
            Custom("button,input,optgroup,select,textarea") {
                FontFamily(.inherit)
                FontSize(100.percent)
                LineHeight(1.15)
                Margin(0)
            }
            Custom("button,select") {
                TextTransform(.none)
            }
            Custom("button,[type='button'],[type='reset'],[type='submit']") {
                UnsafeRawProperty(name: "-webkit-appearance", value: "button")
            }
            Custom("::-moz-focus-inner") {
                BorderStyle(.none)
                Padding(0)
            }
            Custom(":-moz-focusring") {
                UnsafeRawProperty(
                    name: "outline",
                    value: "1px dotted ButtonText"
                )
            }
            Custom(":-moz-ui-invalid") {
                BoxShadow(.none)
            }
            Custom("legend") {
                Padding(0)
            }
            Custom("progress") {
                VerticalAlign(.baseline)
            }
            Custom("::-webkit-inner-spin-button,::-webkit-outer-spin-button") {
                Height(.auto)
            }
            Custom("[type='search']") {
                UnsafeRawProperty(
                    name: "-webkit-appearance",
                    value: "textfield"
                )
                OutlineOffset((-2).px)
            }
            Custom("::-webkit-search-decoration") {
                UnsafeRawProperty(name: "-webkit-appearance", value: "none")
                OutlineOffset((-2).px)
            }
            Custom("::-webkit-file-upload-button") {
                UnsafeRawProperty(name: "-webkit-appearance", value: "button")
                Font(.inherit)
            }
            Custom("summary") {
                Display(.listItem)
            }
        }
    }
}
