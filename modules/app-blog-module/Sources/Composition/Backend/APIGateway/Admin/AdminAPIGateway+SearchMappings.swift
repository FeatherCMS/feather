import BlogAdminAPI
import FeatherApplication
import Foundation

extension AdminAPIGateway {
    func timestamp(_ date: Date) -> Double {
        date.timeIntervalSince1970
    }

    func timestamp(_ date: Date?) -> Double? {
        date.map(timestamp)
    }

    func mapSortDirection(
        _ direction: BlogAdminAPI.Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }

    func map(
        _ page: BlogAdminAPI.Components.Schemas.SearchPageSchema?
    ) -> Search.Page {
        let defaults = Search.Page()
        return
            Search.Page(
                size: page?.size ?? defaults.size,
                number: page?.number ?? defaults.number
            )
            .normalized()
    }
}
