//
//  NoRemindersView.swift
//  Plant Task
//
//  Created by HANAN ABDALLAH on 01/06/1448 AH.
//

import SwiftUI

struct NoRemindersView: View {
    // متغير حالة للتحكم في فتح شاشة إضافة تنبيه جديد عند الضغط على زر (+)
    @State private var showingAddPlant = false

    var body: some View {
        ZStack {
            // 1. خلفية سوداء للشاشة
            Color.black
                .ignoresSafeArea()

            // 2. المحتوى الرئيسي مرتب بشكل عمودي
            VStack(alignment: .leading, spacing: 0) {

                // العنوان العلوي (My Plants 🌱)
                Text("My Plants 🌱")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                // خط فاصل رفيع تحت العنوان
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .padding(.top, 15)

                // النص في منتصف الشاشة
                Spacer()

                HStack {
                    Spacer()
                    Text("No reminders set yet..")
                        .font(.body)
                        .foregroundColor(.gray)
                    Spacer()
                }

                Spacer()
            }

            // 3. زر الإضافة العائم (+) في أسفل اليمين
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showingAddPlant = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(red: 0.2, green: 0.5, blue: 0.4))
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 30)
                }
            }
        }
        .sheet(isPresented: $showingAddPlant) {
            AddPlantView()
        }
    }
}

#Preview {
    NoRemindersView()
        .environmentObject(PlantViewModel())
}
