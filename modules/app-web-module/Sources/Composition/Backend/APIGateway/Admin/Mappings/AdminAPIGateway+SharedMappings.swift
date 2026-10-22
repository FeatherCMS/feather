import FeatherApplication
import FeatherDomain
import FeatherModuleKit
import Foundation
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebDomain

extension AdminAPIGateway {
    func map(_ page: WebAdminAPI.Components.Schemas.SearchPageSchema?)
        -> Search.Page
    {
        .init(
            size: page?.size ?? 20,
            number: page?.number ?? 1
        )
    }

    func mapSortDirection(
        _ direction: WebAdminAPI.Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        direction == .asc ? .asc : .desc
    }
}
