import Foundation
import SGML
import Sitemap
import WebDomain
import WebModule

extension Public.Sitemap {
    enum XML {

        static func render(
            slugs: [String],
            baseURL: String,
            trailingSlashBehavior: Settings.TrailingSlashBehavior
        ) -> String {
            let urls = Set(
                slugs.map {
                    normalizedURL(
                        base: baseURL,
                        slug: $0,
                        trailingSlashBehavior: trailingSlashBehavior
                    )
                }
            )
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
            slug: String,
            trailingSlashBehavior: Settings.TrailingSlashBehavior
        ) -> String {
            var url = base.hasSuffix("/") ? base : base + "/"
            let normalizedSlug = slug.trimmingCharacters(
                in: CharacterSet(charactersIn: "/")
            )
            if !normalizedSlug.isEmpty {
                url += normalizedSlug
                if trailingSlashBehavior == .enforce {
                    url += "/"
                }
            }
            return url
        }

    }
}
