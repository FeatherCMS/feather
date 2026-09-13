import FeatherContracts
import Foundation

public struct NewAdminListRemoveFormInput: Decodable, Sendable {
    public var ids: [String]?
    public var selectedIds: [String]?
    public var page: Int?
    public var search: String?
    public var returnTo: String?
    public var nonce: String?

    private enum CodingKeys: String, CodingKey {
        case selectedIds
        case selectedIdsArray = "selectedIds[]"
        case ids
        case idsArray = "ids[]"
        case page
        case search
        case returnTo
        case nonce = "_nonce"
    }

    public init(
        ids: [String]? = nil,
        selectedIds: [String]? = nil,
        page: Int? = nil,
        search: String? = nil,
        returnTo: String? = nil,
        nonce: String? = nil
    ) {
        self.ids = ids
        self.selectedIds = selectedIds
        self.page = page
        self.search = search
        self.returnTo = returnTo
        self.nonce = nonce
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
            ids = try container.decodeIfPresent(
                [String].self,
                forKey: .idsArray
            )
        }

        if ids == nil {
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
        }

        page = try container.decodeIfPresent(Int.self, forKey: .page)
        search = try container.decodeIfPresent(String.self, forKey: .search)
        returnTo = try container.decodeIfPresent(String.self, forKey: .returnTo)
        nonce = try container.decodeIfPresent(String.self, forKey: .nonce)
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

    public var normalizedReturnTo: String? {
        returnTo?.emptyToNil
    }
}
