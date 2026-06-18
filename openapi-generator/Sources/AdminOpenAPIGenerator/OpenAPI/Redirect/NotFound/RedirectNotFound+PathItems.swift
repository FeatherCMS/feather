import FeatherOpenAPI

struct RedirectNotFoundOverviewPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { RedirectNotFoundOverviewOperation() }
}
