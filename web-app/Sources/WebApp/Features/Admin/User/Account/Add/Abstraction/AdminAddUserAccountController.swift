import HTML
import Hummingbird

protocol AdminAddUserAccountController: Sendable {

    func getAddUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddUserAccountController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/accounts/add/",
            use: getAddUserAccount
        )
        router.post(
            "/admin/user/accounts/add/",
            use: postAddUserAccount
        )
    }
}
