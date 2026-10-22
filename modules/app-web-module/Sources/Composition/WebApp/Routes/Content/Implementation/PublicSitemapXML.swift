import Foundation
import SGML
import Sitemap

enum PublicSitemapXML {

    static func render(
        slugs: [String],
        baseURL: String
    ) -> String {
        let urls = Set(slugs.map { normalizedURL(base: baseURL, slug: $0) })
            .sorted()
            .map { url in Url(children: [Loc(url)]) }
        let document = Document(
            type: .xml,
            root: Urlset(children: urls)
        )
        return document.render(indent: 4)
    }

    private static func normalizedURL(
        base: String,
        slug: String
    ) -> String {
        var url = base.hasSuffix("/") ? base : base + "/"
        let normalizedSlug = slug.trimmingCharacters(
            in: CharacterSet(charactersIn: "/")
        )
        if !normalizedSlug.isEmpty {
            url += normalizedSlug + "/"
        }
        return url
    }

}
