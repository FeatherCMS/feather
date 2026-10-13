import Foundation
import RSS
import SGML
import WebContracts

enum PublicRSSXML {

    static func render(
        title: String,
        description: String,
        siteURL: String,
        items: [WebRSSItem]
    ) -> String {
        let sortedItems =
            items
            .filter { !$0.url.isEmpty }
            .sorted { lhs, rhs in
                switch (lhs.publicationDate, rhs.publicationDate) {
                case (let lhs?, let rhs?): lhs > rhs
                case (_?, nil): true
                case (nil, _?): false
                case (nil, nil):
                    lhs.title.localizedCaseInsensitiveCompare(rhs.title)
                        == .orderedAscending
                }
            }

        let channelItems = sortedItems.map(makeItem)
        let document = Document(
            type: .xml,
            root: Rss(
                channels: [
                    Channel(
                        children: [
                            Title(title),
                            Description(description),
                            Link(siteURL),
                        ] + channelItems
                    )
                ]
            )
        )
        return document.render(indent: 4)
    }

    private static func makeItem(_ item: WebRSSItem) -> Item {
        var children: [any ItemContent] = [
            Guid(item.url, isPermalink: true),
            Title(item.title),
            Description(item.description),
        ]
        if let publicationDate = item.publicationDate {
            children.append(PubDate(dateString(publicationDate)))
        }
        return Item(children: children)
    }

    private static func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter.string(from: date)
    }

}
