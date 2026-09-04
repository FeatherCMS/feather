import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AppWebPagePage: Leaf {
    let state: AppGetWebPageModel

    func html() -> Main {
        Main {
            AppPublicStyleAnchor().html()
            Div {
                Article {
                    Div {
                        P("Page").class("public-eyebrow")
                        H1(state.title)
                        if !state.excerpt.isEmpty {
                            P(state.excerpt)
                        }
                    }
                    .class("public-heading")

                    if let imageURL = state.imageURL {
                        Div {
                            Img(src: imageURL, alt: state.title)
                        }
                        .class("public-image")
                    }

                    AppPublicTextBlock(text: state.content).html()
                }
                .class("public-panel")
            }
            .class("public-container")
        }
        .class("public-shell")
    }
}
