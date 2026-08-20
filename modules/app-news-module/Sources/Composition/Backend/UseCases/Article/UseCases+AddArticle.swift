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

    public func makeAddArticle() -> AddArticle {
        .init(
            authorizer: authorizer,
            transaction: articleTransaction()
        )
    }
}
