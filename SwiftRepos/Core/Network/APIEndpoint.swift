import Foundation

enum APIEndpoint {
    case searchRepositories(page: Int)
    case pullRequests(owner: String, repoName: String)

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        
        switch self {
        case .searchRepositories(let page):
            components.path = "/search/repositories"
            components.queryItems = [
                URLQueryItem(name: "q", value: "language:Swift"),
                URLQueryItem(name: "sort", value: "stars"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
            
        case .pullRequests(let owner, let repoName):
            components.path = "/repos/\(owner)/\(repoName)/pulls"
        }
        
        return components.url
    }
}
