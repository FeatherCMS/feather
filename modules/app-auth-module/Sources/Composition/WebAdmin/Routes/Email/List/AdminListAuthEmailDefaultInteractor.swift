import AuthAdminAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

struct AdminListAuthEmailDefaultInteractor: AdminListAuthEmailInteractor {
    let repository: any AdminListAuthEmailRepository

    func execute(
        page: Int,
        size: Int,
        search: String?,
        userID: String?
    ) async throws -> (
        items: [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema],
        identityNames: [String: String],
        total: Int,
        page: Int, size: Int
    ) {
        try await repository.list(
            page: page,
            size: size,
            search: search,
            userID: userID
        )
    }
}
