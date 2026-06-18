import Hummingbird
import WebStandards

func buildAppRoutes(
    router: Router<AppRequestContext>,
    authRouter: Router<AppRequestContext>,
    renderingEngine: DefaultRenderingEngine,
    themeRenderer: ThemeRenderer,
    themeContextFactory: ThemeContextFactory,
    loginRepository: AppLoginUserOpenAPIRepository,
    logoutRepository: AppLogoutUserOpenAPIRepository,
    publicContentRepository: AppPublicContentOpenAPIRepository,
    styleshetCollector: GlobalStylesheetCollector
) {
    AppGetStylesheet(
        globalStylesheetCollector: styleshetCollector
    )
    .controller.route(on: router)

    AppLoginUser(
        repository: loginRepository,
        renderingEngine: renderingEngine
    )
    .controller.route(on: router)

    AppLogoutUser(
        repository: logoutRepository
    )
    .controller.route(on: router)

    AppPublicContent(
        repository: publicContentRepository,
        themeRenderer: themeRenderer,
        themeContextFactory: themeContextFactory
    )
    .controller.route(on: router)

    AppGetHome(
        repository: publicContentRepository,
        themeRenderer: themeRenderer,
        themeContextFactory: themeContextFactory
    )
    .controller.route(on: authRouter)
}
