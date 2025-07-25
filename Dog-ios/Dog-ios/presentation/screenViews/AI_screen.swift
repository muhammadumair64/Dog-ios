import SwiftUI
import GoogleGenerativeAI

// MARK: - AIScreen View
struct AIScreen: View {
    
    // MARK: - Dependencies
    private let geminiModel = GenerativeModel(
        name: "gemini-1.5-flash",
        apiKey: "AIzaSyAFgJCBsh92JSpQczp4jZM3orgLQtSaYcc"
    )
    
    // MARK: - State
    @State private var latitudeInput: String = ""
    @State private var longitudeInput: String = ""
    @State private var responseMessage: String = "Enter latitude and longitude to discover top cities in that region."
    @State private var isLoading: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            headerView
            responseView
            coordinatesInputView
            actionButton
        }
        .padding()
    }
    
    // MARK: - Subviews
    private var headerView: some View {
        Text("Top Cities Explorer")
            .font(.custom(FontHelper.bold.rawValue, size: 28))
            .foregroundColor(.indigo)
            .padding(.top, 40)
    }
    
    private var responseView: some View {
        ZStack {
            ScrollView {
                Text(LocalizedStringKey(responseMessage))
                    .font(.custom(FontHelper.regular.rawValue, size: 18))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: 300)
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                    .scaleEffect(2)
            }
        }
    }
    
    private var coordinatesInputView: some View {
        VStack(spacing: 12) {
            InputField(title: "Latitude", text: $latitudeInput)
            InputField(title: "Longitude", text: $longitudeInput)
        }
    }
    
    private var actionButton: some View {
        Button(action: generateCityListUsingCoordinates) {
            Text("Get Top 5 Cities")
                .font(.custom(FontHelper.bold.rawValue, size: 16))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.indigo)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
    
    // MARK: - AI Prompt Logic
    private func generateCityListUsingCoordinates() {
        guard let lat = Double(latitudeInput), let lon = Double(longitudeInput) else {
            print("Invalid input for lat/lon.")
            responseMessage = "Please enter valid numeric coordinates."
            return
        }
        
        isLoading = true
        responseMessage = ""
        
        let prompt = """
        Based on the geographical coordinates (latitude: \(lat), longitude: \(lon)), identify the country these coordinates belong to.

        Then, list only the top 5 most popular or significant cities from that country. Do **not** mention the country name.

        Just return the city names, separated by a `*` symbol. Do **not** include any extra text, explanation, numbering, or bullet points. Return **only** the 5 city names in a single line.

        Example format: City1 * City2 * City3 * City4 * City5
        """

        print("Gemini Prompt: \(prompt)")
        
        Task {
            do {
                let result = try await geminiModel.generateContent(prompt)
                let output = result.text ?? "No response received."
                print("Gemini Response: \(output)")
                updateUI(message: output)
            } catch {
                print("Gemini generation failed: \(error.localizedDescription)")
                updateUI(message: "AI generation failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateUI(message: String) {
        DispatchQueue.main.async {
            responseMessage = message
            isLoading = false
            latitudeInput = ""
            longitudeInput = ""
        }
    }
}

// MARK: - Input Field
struct InputField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        TextField(title, text: $text)
            .keyboardType(.decimalPad)
            .font(.custom(FontHelper.regular.rawValue, size: 16))
            .padding()
            .background(Color.indigo.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
            .disableAutocorrection(true)
    }
}

// MARK: - Font Helper
enum FontHelper: String {
    case regular = "SFProText-Regular"
    case bold = "SFProText-Bold"
}
