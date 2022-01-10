//
//  RubyFuriAPISampleView.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul | RP on 2022/01/10.
//

import SwiftUI
import Alamofire

struct RubyFuriAPISampleView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var gradeSelection = 0
    @State private var textToAPI: String = ""
    @State private var APIResponseText: String = ""
    @State var isAPILoading:Bool = false


    let session = KPAPISession(session: Session.default)
    
    var body: some View {
        ZStack {
            if self.isAPILoading {
                Color(red: 0, green: 0, blue: 0, opacity: 0.3)
                    .ignoresSafeArea()
                    .zIndex(1)
                ProgressView("ロード中")
                    .scaleEffect(x: 1, y: 1, anchor: .center)
                    .padding(.all, 24)
                    .background(Color.white)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                    .cornerRadius(16)
                    .zIndex(2)
            }
            VStack {
                TextField("文章を入力してください", text: $textToAPI)
                    .textFieldStyle(.roundedBorder)
                    .border(.gray, width: 1)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                
                HStack {
                    HStack {
                        Text("レベル:")
                        Picker("変更レベルを選びください", selection: $gradeSelection) {
                            ForEach(0..<RubyFuriGrade.allCases.count) { grade in
                                Text(RubyFuriGrade.allCases[grade].gradeTitle)
                            }
                        }
                        .compositingGroup()
                        .clipped()
                    }
                    Button("送信") {
                        isAPILoading = true
                        if textToAPI.isEmpty {
                            APIResponseText = "文章を入力してください"
                            isAPILoading = false
                        }
                        else {
                            session.request(api: RubyFuriAPIRequest(text: textToAPI, grade: RubyFuriGrade.allCases[gradeSelection].rawValue)) { result in
                                switch result {
                                    case let .success(model):
                                    APIResponseText = model.description
                                    case let .failure(error):
                                    APIResponseText = error.localizedDescription
                                }
                                isAPILoading = false
                            }
                        }
                    }
                    .frame(minWidth: 70, minHeight: 30)
                    .buttonBorderShape(ButtonBorderShape.roundedRectangle)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth:1))
                }
                .padding(3)

                Text("レベル説明: \(RubyFuriGrade.allCases[gradeSelection].description)")

                ScrollView {
                    Text(APIResponseText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(.black, width: 0.5)
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
            }
            .navigationBarTitle(Text("RubyFuriAPISampleView"), displayMode: .inline)
            .navigationBarItems(
                leading: Button("戻る") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .navigationBarBackButtonHidden(true)
        }
        .disabled(isAPILoading)
    }
}
