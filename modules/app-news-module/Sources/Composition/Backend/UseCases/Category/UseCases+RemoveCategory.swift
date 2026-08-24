import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import NewsApplication
import NewsInfrastructure
import SystemInfrastructure
import WebDomain
import WebInfrastructure

extension UseCases {

    public func makeRemoveCategory() -> RemoveCategory {
        .init(
            authorizer: authorizer,
            transaction: categoryArticlesTransaction()
        )
    }
}
