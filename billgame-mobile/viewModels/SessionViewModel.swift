import Foundation

class SessionViewModel : ObservableObject{
    @Published var currentSession : Session?
    
    var sessionService : SessionService
    
    init () {
        sessionService = SessionService()
        Task {
            await self.getCurrentSession()
        }
    }
    
    func getCurrentSession () async -> Void{
        guard let sessionDTO = await sessionService.fetchCurrentSession() else {
            currentSession = nil
            return
        }
        
        currentSession = Session(adresse: sessionDTO.adresse)
    }
}
