import SwiftUI

struct StartView: View {
    // 1. متغير حالة لمراقبة ما إذا كان يجب فتح شاشة إضافة التنبيه أم لا
    @State private var showingAddPlant = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack {
                    Text("My Plants 🌱")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Image("plant_placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                
                VStack(spacing: 8) {
                    Text("Start your plant journey!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Now all your plants will be in one place and we will help you take care of them :) 🌱")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                Spacer()
                
                // 2. زر الانتقال لشاشة Set Reminder
                Button(action: {
                    showingAddPlant = true // عند الضغط نغير الحالة لفتح الشاشة
                }) {
                    Text("Set Plant Reminder")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.2, green: 0.5, blue: 0.4))
                        .cornerRadius(25)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        // 3. أمر الـ Sheet لفتح شاشة AddPlantView عندما تصبح القيمة true
        .sheet(isPresented: $showingAddPlant) {
            AddPlantView()
        }
    }
}

#Preview {
    StartView()
}
