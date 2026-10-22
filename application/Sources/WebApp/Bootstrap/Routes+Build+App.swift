import Foundation
import FeatherWebShared
import FeatherModuleKit
import MediaWebAdmin
import ContactFrontend
import NewsletterFrontend
import WebModuleWebAdmin
import WebModuleWebApp
import AnalyticsFrontend
import RedirectWebAdmin
import UserWebAdmin
import SystemWebAdmin
import FeatherWebAdmin
import FeatherApplication
import Hummingbird
import WebApplication
import NewsFrontend
import AccountWebApp
import NIOCore
import HTML
import WebBuilders
import WebComponents

private struct AccountPublicPageRendering: AccountWebApp.PublicPageRendering {
    let renderingEngine: any RenderingEngine

    func renderPublicPage<T: Component>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> Response where T.HTML: FlowContent {
        let html = renderingEngine.renderPublicPage(
            request: request,
            title: title,
            description: description,
            imagePath: imagePath,
            content: content
        )
        return Response(
            status: .ok,
            headers: [.contentType: "text/html; charset=utf-8"],
            body: .init(byteBuffer: ByteBuffer(string: html.content))
        )
    }
}
import AccountWebApp
import NIOCore
import HTML
import WebBuilders
import WebComponents

private struct AccountPublicPageRendering: AccountWebApp.PublicPageRendering {
    let renderingEngine: any RenderingEngine

    func renderPublicPage<T: Component>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> Response where T.HTML: FlowContent {
        let renderedHTML = renderingEngine.renderPublicPage(
            request: request,
            title: title,
            description: description,
            imagePath: imagePath,
            content: content
        )
        return Response(
            status: .ok,
            headers: [.contentType: "text/html; charset=utf-8"],
            body: .init(byteBuffer: ByteBuffer(string: renderedHTML.content))
        )
    }
}

func buildAppRoutes(
    router: Hummingbird.Router<DefaultRequestContext>,
    authRouter: Hummingbird.Router<DefaultRequestContext>,
    environment: AppEnvironment,
    environment: AppEnvironment,
    renderingEngine: DefaultRenderingEngine,
    themeRenderer: DefaultThemeRenderer,
    publicContentEvents: any EventPublisher,
    apiBuilder: APIBuilder,
    mediaResolver: MediaResolver,
    publicOrigins: AppPublicOriginConfiguration
) {
    AccountWebApp.Router(
        environment: environment,
        renderingEngine: AccountPublicPageRendering(
            renderingEngine: renderingEngine
        )
    )
    .route(on: router)

    AccountWebApp.Router(
        environment: environment,
        renderingEngine: AccountPublicPageRendering(
            renderingEngine: renderingEngine
        )
    )
    .route(on: router)

    AppContactFormSubmission(apiBuilder: apiBuilder.contact).route(on: router)

    AppNewsletterCampaignSubscription(apiBuilder: apiBuilder.newsletter)
        .route(on: router)

    AppPublicContent(
        events: publicContentEvents,
        themeRenderer: themeRenderer,
        contentRenderer: DefaultMarkdownRenderer(
            events: publicContentEvents,
            mediaResolver: mediaResolver
        ),
        apiBaseURL: apiBuilder.web.baseURL,
        publicOrigins: publicOrigins,
        mediaResolver: mediaResolver
    )
    .controller.route(on: router)

}
