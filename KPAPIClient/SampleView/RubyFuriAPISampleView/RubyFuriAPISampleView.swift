//
//  RubyFuriAPISampleView.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2022/01/10.
//

import SwiftUI
import Alamofire

struct RubyFuriAPISampleView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel = RubyFuriViewModel()

    var body: some View {
        ZStack {
            if viewModel.status == .Loading {
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
                TextField("文章を入力してください", text: $viewModel.textToAPI)
                    .textFieldStyle(.roundedBorder)
                    .border(.gray, width: 1)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                
                HStack {
                    HStack {
                        Text("レベル:")
                        Picker("変更レベルを選びください", selection: $viewModel.gradeSelection) {
                            ForEach(0..<RubyFuriGrade.allCases.count) { grade in
                                Text(RubyFuriGrade.allCases[grade].gradeTitle)
                            }
                        }
                        .compositingGroup()
                        .clipped()
                    }
                    Button("送信") {
                        hideKeyboard()
                        if !viewModel.textToAPI.isEmpty {
                            viewModel.fetchRubyFuriResult()
                        }
                    }
                    .frame(minWidth: 70, minHeight: 30)
                    .buttonBorderShape(ButtonBorderShape.roundedRectangle)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth:1))
                }
                .padding(3)

                Text("レベル説明: \(RubyFuriGrade.allCases[viewModel.gradeSelection].description)")

                ScrollView {
                    Text(viewModel.resultText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(.black, width: 0.5)
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
            }
            .navigationBarTitle(Text("RubyFuriAPISample"), displayMode: .inline)
            .navigationBarItems(
                leading: Button("戻る") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("リセット") {
                    self.viewModel.reset()
                }
            )
            .navigationBarBackButtonHidden(true)
        }
        .alert(isPresented: Binding<Bool>(
            get: { self.viewModel.status == .APIFailure },
            set: { _ in self.viewModel.status = .Idle }
        )) {
            Alert(title: Text(self.viewModel.error?.description ?? "Error"),
                  message: nil,
                  dismissButton: .default(Text("OK")))
        }
        .disabled(viewModel.status == .Loading)
    }
}
