//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminBody<T: Component>: Component where T.HTML: FlowContent {

    public let content: T
    public let showsFooter: Bool
    public let allowsPasswordManagerAutofill: Bool

    public init(
        content: T,
        showsFooter: Bool = true,
        allowsPasswordManagerAutofill: Bool = false
    ) {
        self.content = content
        self.showsFooter = showsFooter
        self.allowsPasswordManagerAutofill = allowsPasswordManagerAutofill
    }

    public func html(context: inout BuilderContext) -> Body {
        Body {
            context.build(content)

            if showsFooter {
                Div {
                    P("Powered by Feather CMS")
                }
                .id("footer")
            }
        }
        .if(!allowsPasswordManagerAutofill) {
            $0.setAttribute(name: "data-1p-ignore", value: "")
        }
    }
}
