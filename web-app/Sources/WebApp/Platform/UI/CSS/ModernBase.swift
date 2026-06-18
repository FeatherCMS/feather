//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 07..
//

import CSS
import WebStandards

extension CSS {

    struct ModernBase: GlobalStyleComponent {

        static func rules() -> [any Rule] {
            Media(
                .screen && .custom("-webkit-min-device-pixel-ratio: 2")
                    || .screen && .minResolution("2dppx")
            ) {
                Custom("body") {
                    UnsafeRawProperty(
                        name: "-moz-osx-font-smoothing",
                        value: "grayscale"
                    )
                    UnsafeRawProperty(
                        name: "-webkit-font-smoothing",
                        value: "antialiased"
                    )
                }
            }
            Media {
                Custom("h1,h2,h3,h4,h5,h6,p,figure,blockquote,dd,dl,pre") {
                    Margin(0)
                }
                Custom("a") {
                    TextDecoration(.none)
                }
                Custom("a:hover") {
                    TextDecoration(.underline)
                }
                Custom("a:active,a:hover") {
                    OutlineWidth(0)
                }
                Custom("::-webkit-input-placeholder") {
                    Color(.inherit)
                    Opacity(0.54)
                }
                Custom("::selection") {
                    TextShadow(.none)
                }
                Custom(":focus") {
                    OutlineWidth(0)
                }
                Custom("nav ol,nav ul") {
                    ListStyle(.none)
                }
                Custom(
                    "#menuToggle:not(:checked) ~ nav .has-submenu > .sub-menu > li > a"
                ) {
                    PaddingLeft(1.5.rem)
                }
                Custom("hr") {
                    Display(.block)
                    Margin(vertical: 1.em, horizontal: 0)
                    Padding(0)
                    Border(0)
                    BorderTop(1.px, .solid, "#ccc")
                }
                Custom("fieldset") {
                    Margin(0)
                    Padding(0)
                    Border(0)
                }
                Custom("textarea") {
                    Resize(.vertical)
                }
                Custom("svg,img,canvas,video,audio,iframe") {
                    VerticalAlign(.middle)
                    MaxWidth(100.percent)
                }
            }
            Media {
                Custom("::selection") {
                    Background(color: "b3d7fd")
                }
            }
            Media(.screen && .prefersColorScheme(.dark)) {
                Custom("::selection") {
                    Background(color: "b3d7fd")
                }
            }
        }

    }
}
