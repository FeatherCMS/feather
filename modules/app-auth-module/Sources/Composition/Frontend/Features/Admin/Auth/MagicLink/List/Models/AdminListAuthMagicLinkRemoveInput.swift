import FeatherContracts
import Foundation

struct AdminListAuthMagicLinkRemoveInput: Decodable, Sendable {
    private var selectedIds: [String]?
    private var selectedIdsArray: [String]?
    let page: Int?
    let search: String?
    let userId: String?

    private enum CodingKeys: String, CodingKey {
        case selectedIds
        case selectedIdsArray = "selectedIds[]"
        case page
        case search
        case userId
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
            selectedIds = nil
        }
        selectedIdsArray = try container.decodeIfPresent(
            [String].self,
            forKey: .selectedIdsArray
        )
        page = try container.decodeIfPresent(Int.self, forKey: .page)
        search = try container.decodeIfPresent(String.self, forKey: .search)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
    }

    var normalizedSelectedIds: [String] {
        selectedIds ?? selectedIdsArray ?? []
    }

    var normalizedPage: Int {
        max(page ?? 1, 1)
    }

    var normalizedSearch: String? {
        search?.emptyToNil
    }

    var normalizedUserID: String? {
        userId?.emptyToNil
    }
}
