import Foundation

class HttpService {
    private let session: URLSession
    private let authTokenStore: AuthTokenStore = AuthTokenStore()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(url: URL, success: @escaping (Data, [AnyHashable: Any]?) -> Void, failure: @escaping (Error) -> Void) {
        performRequest(url: url, httpMethod: "GET", success: success, failure: failure)
    }

    func post(url: URL, body: Data?, success: @escaping (Data, [AnyHashable: Any]?) -> Void, failure: @escaping (Error) -> Void) {
        performRequest(url: url, httpMethod: "POST", body: body, success: success, failure: failure)
    }

    func put(url: URL, body: Data?, success: @escaping (Data, [AnyHashable: Any]?) -> Void, failure: @escaping (Error) -> Void) {
        performRequest(url: url, httpMethod: "PUT", body: body, success: success, failure: failure)
    }
    
    func patch(url: URL, body: Data?, success: @escaping (Data, [AnyHashable: Any]?) -> Void, failure: @escaping (Error) -> Void) {
       performRequest(url: url, httpMethod: "PATCH", body: body, success: success, failure: failure)
   }

    func delete(url: URL, success: @escaping (Data, [AnyHashable: Any]?) -> Void, failure: @escaping (Error) -> Void) {
        performRequest(url: url, httpMethod: "DELETE", success: success, failure: failure)
    }

    private func performRequest(url: URL, httpMethod: String, body: Data? = nil, success: @escaping (Data, [AnyHashable: Any]?) -> Void, failure: @escaping (Error) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = authTokenStore.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                failure(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                failure(NSError(domain: "HttpService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Réponse invalide"]))
                return
            }
            
            let headers = httpResponse.allHeaderFields
            
            if (200...299).contains(httpResponse.statusCode) {
                success(data, headers)
            } else {
                let errorInfo = String(data: data, encoding: .utf8) ?? "Erreur inconnue"
                failure(NSError(domain: "HttpService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorInfo]))
            }
        }

        task.resume()
    }

}
