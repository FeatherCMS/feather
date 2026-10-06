import Foundation

struct VideoMarkdownBlockRenderer: WebMarkdownBlockRenderer {
    let name = "Video"

    private let allowedEmbedHosts = [
        "youtube.com",
        "youtube-nocookie.com",
        "vimeo.com",
        "facebook.com",
        "albumizr.com",
    ]

    func render(
        request: WebMarkdownBlockRendererRequest
    ) async -> String? {
        guard
            let source = source(from: request),
            let url = URL(string: source),
            isAllowed(url: url, source: source)
        else {
            return nil
        }

        let kind = request.arguments["kind"]
            ?? (source.hasPrefix("/") ? "file" : "embed")
        let escapedSource = escapeHTML(source)

        switch kind.lowercased() {
        case "file":
            guard source.hasPrefix("/") else { return nil }
            return """
            <figure class="markdown-video markdown-video--file"><video controls preload="metadata" src="\(escapedSource)">Your browser does not support video playback.</video></figure>
            """
        case "embed":
            guard isAllowedEmbedHost(url.host) else { return nil }
            return """
            <figure class="markdown-video markdown-video--embed"><iframe src="\(escapedSource)" title="Embedded video" loading="lazy" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure>
            """
        default:
            return nil
        }
    }

    private func source(
        from request: WebMarkdownBlockRendererRequest
    ) -> String? {
        if let source = request.arguments["source"], !source.isEmpty {
            return source
        }

        let raw = request.rawArguments.trimmingCharacters(in: .whitespacesAndNewlines)
        let legacy = raw.isEmpty
            ? request.children.map(\.html).joined()
                .replacingOccurrences(of: "<p>", with: "")
                .replacingOccurrences(of: "</p>", with: "")
                .replacingOccurrences(of: "<br>", with: "")
                .replacingOccurrences(of: "<br/>", with: "")
                .replacingOccurrences(of: "<br />", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            : raw

        if legacy.hasPrefix("{") && legacy.hasSuffix("}") {
            let value = legacy.dropFirst().dropLast()
                .trimmingCharacters(in: .whitespacesAndNewlines)
            guard let data = value.data(using: .utf8) else { return nil }
            return try? JSONDecoder().decode(String.self, from: data)
        }

        let decoded = legacy
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
        let quotePairs = [("“", "”"), ("\"", "\""), ("‘", "’"), ("'", "'")]
        for (opening, closing) in quotePairs
            where decoded.hasPrefix(opening) && decoded.hasSuffix(closing)
        {
            return String(decoded.dropFirst(opening.count).dropLast(closing.count))
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return decoded.isEmpty ? nil : decoded
    }

    private func isAllowed(url: URL, source: String) -> Bool {
        if source.hasPrefix("/") {
            return true
        }
        return url.scheme?.lowercased() == "https"
            && isAllowedEmbedHost(url.host)
    }

    private func isAllowedEmbedHost(_ host: String?) -> Bool {
        guard let host = host?.lowercased() else { return false }
        return allowedEmbedHosts.contains { host == $0 || host.hasSuffix(".\($0)") }
    }

    private func escapeHTML(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}
