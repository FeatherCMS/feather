import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebDomain

extension Settings {
    struct Router {
        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine
        let root: WebRoute

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            let controller = AdminEditSettings(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            let path = root.appending(pathComponent: "settings")
            router.get(path.routerPath, use: controller.getEditSettings)
            router.post(path.routerPath, use: controller.postEditSettings)
        }
    }
}
