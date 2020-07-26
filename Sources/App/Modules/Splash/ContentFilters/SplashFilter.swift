//
//  SplashFilter.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 18..
//

import Vapor
import Fluent
import ViperKit
import Splash

struct SplashFilter: ContentFilter {
    var key: String { "swift-splash" }
    var label: String { "Splash (Swift)" }
    
    func filter(_ input: String) -> String {
        input.replace("<pre><code class=\"language-swift\">(.*?)</code></pre>", options: .dotMatchesLineSeparators) { c in
            let highlighter = SyntaxHighlighter(format: HTMLOutputFormat())
            let code = highlighter.highlight(c[1]).trimmingCharacters(in: .whitespacesAndNewlines)
            return "<pre><code class=\"language-swift\">" + code + "</code></pre>"
        }
    }
}
