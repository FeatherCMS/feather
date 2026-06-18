import CSS
import HTML
import SGML
import SVG
import WebStandards

struct AppHomePage: Component, FlowContent {

    var state: AppGetHomeModel

    private var siteTitle: String {
        switch state {
        case .page(let content):
            return content.siteSettings.title
        case .defaultHome(let siteSettings, _, _, _):
            return siteSettings.title
        }
    }

    func selectors() -> [any Selector] {
        Class("home-shell") {
            Display(.grid)
            MinHeight(100.vh)
            Padding(vertical: 24.px, horizontal: 20.px)
            UnsafeRawProperty(name: "align-content", value: "start")
            UnsafeRawProperty(name: "justify-items", value: "center")
            UnsafeRawProperty(
                name: "background",
                value: """
                    radial-gradient(circle at top, rgba(156, 136, 255, 0.16) 0%, transparent 34%),
                    radial-gradient(circle at bottom right, rgba(28, 27, 31, 0.08) 0%, transparent 30%),
                    linear-gradient(180deg, var(--cms-gray-1) 0%, var(--cms-white) 100%)
                    """
            )
        }
        Class("home-frame") {
            UnsafeRawProperty(name: "width", value: "min(100%, 64rem)")
            Display(.grid)
            Gap(18.px)
        }
        Class("home-content") {
            Display(.grid)
            Gap(22.px)
            Padding(vertical: 8.px, horizontal: 0.px)
        }
        Class("home-panel") {
            Display(.grid)
            Gap(20.px)
            Padding(0.px)
        }
        Class("home-heading") {
            Display(.grid)
            Gap(6.px)
        }
        Custom(".home-heading .home-kicker") {
            Margin(0)
            UnsafeRawProperty(name: "color", value: "var(--cms-accent-color)")
            FontSize(0.75.rem)
            FontWeight(700)
            LetterSpacing(0.16.em)
            TextTransform(.uppercase)
        }
        Custom(".home-heading h1") {
            Margin(0)
            Color(.variable("cms-strong-font"))
            UnsafeRawProperty(
                name: "font-size",
                value: "clamp(2.2rem, 5vw, 3rem)"
            )
            LineHeight(1.05)
            LetterSpacing((-0.04).em)
        }
        Custom(".home-heading h4") {
            Margin(0.px)
            Color(.variable("cms-strong-font"))
            FontSize(1.rem)
        }
        Class("home-copy") {
            Display(.grid)
            Gap(8.px)
        }
        Custom(".home-copy p") {
            Margin(0)
            Color(.variable("cms-light-font"))
            FontSize(0.96.rem)
            LineHeight(1.5)
        }
        Class("home-actions") {
            Display(.flex)
            FlexWrap(.wrap)
            Gap(12.px)
        }
        Class("home-button") {
            Display(.inlineFlex)
            AlignItems(.center)
            JustifyContent(.center)
            MinWidth(8.rem)
            Padding(vertical: 10.px, horizontal: 16.px)
            BorderRadius(999.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            TextDecoration(.none)
            FontWeight(600)
            LineHeight(1)
        }
        Class("home-primary") {
            Background(color: .color(.variable("cms-strong-font")))
            BorderColor(.variable("cms-strong-font"))
            Color(.variable("cms-white"))
        }
        Class("home-secondary") {
            Background(color: .color(.variable("cms-white")))
            Color(.variable("cms-strong-font"))
        }
        Custom(".home-button:hover") {
            Transform(.translateY((-1).px))
            BoxShadow(
                0,
                8.px,
                blur: 18.px,
                color: .init(r: 0, g: 0, b: 0, a: 0.08)
            )
        }
        Class("home-user") {
            Display(.grid)
            Gap(6.px)
            Padding(top: 14.px, right: 0, bottom: 0, left: 0)
            BorderTop(1.px, .solid, .variable("cms-gray-2"))
        }
        Custom(".home-user .home-label") {
            Margin(0)
            Color(.variable("cms-light-font"))
            FontSize(0.85.rem)
            TextTransform(.uppercase)
            LetterSpacing(0.08.em)
        }
        Custom(".home-user .home-name") {
            Margin(0)
            Color(.variable("cms-strong-font"))
            FontSize(1.rem)
            FontWeight(600)
        }
        Class("home-section") {
            Display(.grid)
            Gap(12.px)
            Padding(24.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(20.px)
            Background(color: .color(.variable("cms-white")))
            UnsafeRawProperty(name: "box-shadow", value: "var(--cms-shadow)")
        }
        Custom(".home-section h4") {
            Margin(0)
            Color(.variable("cms-strong-font"))
            FontSize(1.rem)
        }
        Custom(".home-section p") {
            Margin(0)
            Color(.variable("cms-light-font"))
            LineHeight(1.6)
        }
    }

    private func navigationStyle() -> String {
        """
        #navigation {
            margin-top: 16px;
            overflow: hidden;
            border-bottom: 3px solid var(--cms-gray-1);
            border: 1px solid var(--cms-gray-3);
            border-radius: 20px;
            background: var(--cms-white);
            box-shadow: var(--cms-shadow);
        }
        #navigation > a {
            display: block;
            line-height: 0;
            padding: 8px;
            text-align: center;
        }
        #navigation > a img {
            height: 44px;
            width: auto;
        }
        #navigation nav svg {
            width: 24px;
            height: 24px;
        }
        #navigation #primary-menu-button {
            display: none;
        }
        #navigation #primary-menu-button + label {
            position: absolute;
            top: 22px;
            left: 0;
            margin: 0;
            line-height: 0;
            padding: 12px;
            color: var(--cms-strong-font);
        }
        #navigation #primary-menu-button + label:hover {
            cursor: pointer;
        }
        #navigation .menu-items {
            max-height: 0px;
            transition: max-height .3s ease-in-out 0s;
            margin-top: 6px;
        }
        #navigation .menu-items a {
            display: block;
            padding: 16px;
            border-top: 0.5px solid var(--cms-gray-2);
            color: var(--cms-strong-font);
            background: var(--cms-white);
        }
        #navigation .menu-items a:hover {
            color: var(--cms-link-hover);
        }
        #navigation input:checked ~ .menu-items {
            max-height: 999px;
        }
        #navigation line {
            transition: transform .3s ease-in-out 0s;
            transform-origin: 50% 50%;
        }
        #navigation input:checked ~ label line:nth-child(1) {
            transform: translateX(-50px);
        }
        #navigation input:checked ~ label line:nth-child(2) {
            transform: rotate(45deg) translateY(6px);
        }
        #navigation input:checked ~ label line:nth-child(3) {
            transform: rotate(-45deg) translateY(-6px);
        }
        @media screen and (min-width: 600px) {
            #navigation {
                display: grid;
                grid-template-columns: auto 1fr;
            }
            #navigation > a {
                grid-column: span 1;
            }
            #navigation nav {
                overflow: hidden;
                grid-column: span 1;
            }
            #primary-menu-button ~ label {
                display: none;
            }
            #navigation nav .menu-items {
                display: block;
                max-height: none;
                text-align: right;
                padding: 8px;
                margin-top: 0;
            }
            #navigation nav .menu-items a {
                padding: 8px;
                display: inline-block;
                border: none;
            }
        }
        """
    }

    func content() -> some BasicTag {
        Main {
            Div {
                Style(navigationStyle())

                Header {
                    A {
                        Picture {
                            Img(
                                src:
                                    "\(AppEnvironmentStore.current.publicOrigins.staticBaseURL)/images/logos/logo.png",
                                alt: "Logo of The.Swift.Dev."
                            )
                            .title("The.Swift.Dev.")
                        }
                    }
                        .href("/")
                    Nav {
                        Input()
                            .type(.checkbox)
                            .id("primary-menu-button")
                            .name("menu-button")
                            .class("menu-button")

                        Label {
                            Icon(svg: FeatherIcons.menu())
                        }
                        .for("primary-menu-button")

                        Div {
                            A("Blog").href("/blog/")
                            A("Authors").href("/authors/")
                            A("Tags").href("/tags/")
                        }
                        .class("menu-items")
                    }
                }
                .id("navigation")

                Div {
                    Div {
                        H1("Feather CMS")
                        Div {
                            P("A modern Swift-based CMS.")
                        }
                    }
                    .class("home-heading home-copy")

                    Div {
                        H4("Latest posts")
                        P("Lorem ipsum.")
                    }
                    .class("home-section")

                    Div {
                        P("Powered by CMS content").class("home-label")
                        P(siteTitle).class("home-name")
                    }
                    .class("home-user")

                    Div {
                        A("Blog").href("/blog/")
                            .class("home-button home-primary")
                        A("Sign in").href("/login/")
                            .class("home-button home-secondary")
                    }
                    .class("home-actions")
                }
                .class("home-content")
            }
            .class("home-panel")
        }
        .class("home-shell")
        .setAttribute(name: "role", value: "main")
    }
}
