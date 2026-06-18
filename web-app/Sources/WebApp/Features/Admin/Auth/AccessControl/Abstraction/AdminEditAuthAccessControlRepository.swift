import AdminOpenAPI
import Foundation

protocol AdminEditAuthAccessControlRepository: Sendable {

    func fetchRoles() async throws -> [Components.Schemas
        .UserRoleListItemSchema]

    func fetchPermissions() async throws -> [Components.Schemas
        .SystemPermissionListItemSchema]

    func fetchExistingPairs() async throws -> Set<
        AdminEditAuthAccessControlPair
    >

    func delete(
        pair: AdminEditAuthAccessControlPair
    ) async throws

    func create(
        pair: AdminEditAuthAccessControlPair
    ) async throws
}
