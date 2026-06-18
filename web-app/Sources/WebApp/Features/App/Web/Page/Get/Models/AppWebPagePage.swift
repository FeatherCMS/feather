import HTML
import SGML
import WebStandards

struct AppWebPagePage: Component, FlowContent {
    let state: AppGetWebPageModel

    func content() -> some BasicTag {
        Main {
            AppPublicStyleAnchor()
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

                    AppPublicTextBlock(text: state.content)
                }
                .class("public-panel")
            }
            .class("public-container")
        }
        .class("public-shell")
    }
}
