import Foundation

struct ListBulkRemoveFormInput: Decodable, Sendable {
    var selectedIds: [String]?
    var page: Int?
    var search: String?
    var campaignId: String?

    private enum CodingKeys: String, CodingKey {
        case selectedIds
        case selectedIdsArray = "selectedIds[]"
        case page
        case search
        case campaignId
    }

    init(
        selectedIds: [String]? = nil,
        page: Int? = nil,
        search: String? = nil,
        campaignId: String? = nil
    ) {
        self.selectedIds = selectedIds
        self.page = page
        self.search = search
        self.campaignId = campaignId
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let values = try? container.decodeIfPresent(
            [String].self,
            forKey: .selectedIds
        ) {
            selectedIds = values
        }
        else if let value = try? container.decodeIfPresent(
            String.self,
            forKey: .selectedIds
        ) {
            selectedIds = [value]
        }
        else {
            selectedIds = try container.decodeIfPresent(
                [String].self,
                forKey: .selectedIdsArray
            )
        }

        page = try container.decodeIfPresent(Int.self, forKey: .page)
        search = try container.decodeIfPresent(String.self, forKey: .search)
        campaignId = try container.decodeIfPresent(
            String.self,
            forKey: .campaignId
        )
    }

    var normalizedSelectedIds: [String] {
        selectedIds ?? []
    }

    var normalizedPage: Int {
        max(page ?? 1, 1)
    }

    var normalizedSearch: String? {
        search?.nilIfEmpty
    }
}
