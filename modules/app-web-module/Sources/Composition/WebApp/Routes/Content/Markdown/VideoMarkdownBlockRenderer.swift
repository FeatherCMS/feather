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
        guard let source = request.arguments["source"], !source.isEmpty else {
            return nil
        }
        return source
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
