import FeatherContracts
import Foundation

public struct ListRemoveFormInput: Decodable, Sendable {
    public var ids: [String]?
    public var selectedIds: [String]?
    public var page: Int?
    public var search: String?
    public var campaignId: String?

    private enum CodingKeys: String, CodingKey {
        case selectedIds
        case selectedIdsArray = "selectedIds[]"
        case ids
        case idsArray = "ids[]"
        case page
        case search
        case campaignId
    }

    public init(
        ids: [String]? = nil,
        selectedIds: [String]? = nil,
        page: Int? = nil,
        search: String? = nil,
        campaignId: String? = nil
    ) {
        self.ids = ids
        self.selectedIds = selectedIds
        self.page = page
        self.search = search
        self.campaignId = campaignId
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let values = try? container.decodeIfPresent(
            [String].self,
            forKey: .ids
        ) {
            ids = values
        }
        else if let value = try? container.decodeIfPresent(
            String.self,
            forKey: .ids
        ) {
            ids = [value]
        }
        else {
            ids = try container.decodeIfPresent([String].self, forKey: .idsArray)
        }
        if ids == nil {
            if let values = try? container.decodeIfPresent([String].self, forKey: .selectedIds) {
                selectedIds = values
            }
            else if let value = try? container.decodeIfPresent(String.self, forKey: .selectedIds) {
                selectedIds = [value]
            }
            else {
                selectedIds = try container.decodeIfPresent([String].self, forKey: .selectedIdsArray)
            }
        }

        page = try container.decodeIfPresent(Int.self, forKey: .page)
        search = try container.decodeIfPresent(String.self, forKey: .search)
        campaignId = try container.decodeIfPresent(
            String.self,
            forKey: .campaignId
        )
    }

    public var normalizedSelectedIds: [String] {
        ids ?? selectedIds ?? []
    }

    public var normalizedIds: [String] {
        ids ?? selectedIds ?? []
    }

    public var normalizedPage: Int {
        max(page ?? 1, 1)
    }

    public var normalizedSearch: String? {
        search?.emptyToNil
    }
}
