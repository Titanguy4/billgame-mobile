import Foundation
import Security

class AuthTokenStore {
    
    var token: String? {
        get { retrieveTokenFromKeychain(account: "authToken") }
        set {
            if let token = newValue {
                if !saveTokenToKeychain(token: token, account: "authToken") {
                    print("Error to store token")
                }
            } else {
                SecItemDelete([kSecClass as String: kSecClassGenericPassword, kSecAttrAccount as String: "authToken"] as CFDictionary)
            }
        }
    }
    
    func saveTokenToKeychain(token: String, account: String) -> Bool {
        let tokenData = token.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: tokenData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func retrieveTokenFromKeychain(account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}
