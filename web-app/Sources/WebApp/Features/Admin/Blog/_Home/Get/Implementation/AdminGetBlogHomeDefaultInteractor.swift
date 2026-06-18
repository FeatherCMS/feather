import Hummingbird

struct AdminGetBlogHomeDefaultInteractor: AdminGetBlogHomeInteractor {
    func getHome() async throws -> AdminGetBlogHomeModel {
        .init(title: "Blog module")
    }
}
