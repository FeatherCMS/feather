import FeatherContracts
import Foundation

public struct ListBulkRemoveFormInput: Decodable, Sendable {
    public var selectedIds: [String]?
    public var page: Int?
    public var search: String?
    public var campaignId: String?

    private enum CodingKeys: String, CodingKey {
        case selectedIds
        case selectedIdsArray = "selectedIds[]"
        case page
        case search
        case campaignId
    }

    public init(
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

    public init(from decoder: any Decoder) throws {
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

    public var normalizedSelectedIds: [String] {
        selectedIds ?? []
    }

    public var normalizedPage: Int {
        max(page ?? 1, 1)
    }

    public var normalizedSearch: String? {
        search?.emptyToNil
    }
}
