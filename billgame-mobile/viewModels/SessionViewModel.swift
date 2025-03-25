import Foundation

@MainActor
class SessionViewModel: ObservableObject {
    @Published var currentSession: Session?
    
    var sessionService: SessionService
    
    init() {
        sessionService = SessionService()
        Task {
            await self.getCurrentSession()
        }
    }
    
    func getCurrentSession() async {
        guard let sessionDTO = await sessionService.fetchCurrentSession() else {
            currentSession = nil
            return
        }
        currentSession = Session(from: sessionDTO)
    }
}
