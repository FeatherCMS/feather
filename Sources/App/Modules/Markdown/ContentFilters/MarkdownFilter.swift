//
//  MarkdownFilter.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 18..
//

import FeatherCore
import Ink

struct MarkdownFilter: ContentFilter {
    var key: String { "markdown-ink" }
    var label: String { "Markdown (Ink)" }

    func filter(_ input: String) -> String {
        var parser = MarkdownParser()
        let modifier = Modifier(target: .images) { html, markdown in
            return html.replacingOccurrences(of: "<img src", with: "<img class=\"block br:s\" src")
        }
        parser.addModifier(modifier)
        
        let result = parser.html(from: input.replacingOccurrences(of: "\r", with: "\n"))
        return """
        <div class="wrapper w">
            <section class="m:xl">
                \(result)
            </section>
        </div>
        """
    }
}
