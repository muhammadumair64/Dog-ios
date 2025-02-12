//
//  AI_screen.swift
//  Dog-ios
//
//  Created by Mac Mini on 28/11/2024.
//

import SwiftUI
import GoogleGenerativeAI

struct AI_screen: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: "AIzaSyAxK8GqbCybm0Lqq1VFBXLR__uWqgQB-1g")
    @State var userPrompt = ""
    var prefix = "Answer the following question with medical knowledge and pregnancy-related advice if applicable also if question is not medical related then ignore pregnancy related info also dont tell me that im not a doctor so i have no knowledge i know that u are not im just asking if u have some info over internet or so then provide :"
    
    @State var response: LocalizedStringKey = "How can I help you today?"
    @State var isLoading = false
    
    var body: some View {
        VStack {
            Text("Welcome to Gemini AI")
                .font(.largeTitle)
                .foregroundStyle(.indigo)
                .fontWeight(.bold)
                .padding(.top, 40)
            ZStack{
                ScrollView{
                    Text(response)
                        .font(.title)
                }
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                        .scaleEffect(4)
                }
            }
            
            TextField("Ask anything...", text: $userPrompt, axis: .vertical)
                .lineLimit(5)
                .font(.title3)
                .padding()
                .background(Color.indigo.opacity(0.2), in: Capsule())
                .disableAutocorrection(true)
                .onSubmit {
                    generateResponse()
                }
            
                
        }
        .padding()
    }
    
    func generateResponse(){
        isLoading = true;
        response = ""
        
        Task {
            do {
                let result = try await model.generateContent(prefix+userPrompt)
                isLoading = false
                response = LocalizedStringKey(result.text ?? "No response found")
                userPrompt = ""
            } catch {
                response = "Something went wrong! \n\(error.localizedDescription)"
            }
        }
    }
}
#Preview {
    AI_screen()
}
