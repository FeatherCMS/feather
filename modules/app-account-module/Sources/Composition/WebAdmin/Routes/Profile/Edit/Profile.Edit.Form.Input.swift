import AccountModule

extension Profile.Edit.Form {

    public struct Input: Codable, Sendable, Equatable,
        Hashable
    {

        public var firstName: String? = nil
        public var lastName: String? = nil
        public var profileImageAssetId: String? = nil
    }
}
