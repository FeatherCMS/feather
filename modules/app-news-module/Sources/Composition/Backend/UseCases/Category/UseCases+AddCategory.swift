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

    public func makeAddCategory() -> AddCategory {
        .init(
            authorizer: authorizer,
            transaction: categoryTransaction()
        )
    }
}
