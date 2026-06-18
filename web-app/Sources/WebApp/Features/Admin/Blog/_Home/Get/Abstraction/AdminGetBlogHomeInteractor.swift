import Hummingbird

protocol AdminGetBlogHomeInteractor: Sendable {

    func getHome() async throws -> AdminGetBlogHomeModel
}
