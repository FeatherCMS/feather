struct AdminListAuthSessionModel: Sendable {
    struct Item: Sendable {
        let id: String
        let authenticationType: String
        let authenticationReference: String
        let expiresAt: Double
        let isPersistent: Bool
        let createdAt: Double
        let updatedAt: Double
    }

    let identityID: String
    let items: [Item]
}
