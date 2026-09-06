// import 'package:flutter/services.dart';

// import 'package:http/http.dart' as http;

// class PdfHelper {
//   static Future<void> generateInvoicePdf({
//     required int orderNo,
//     required List<OrderDetailModel> items,
//     required int totalQuantity,
//     required double totalPrice,
//     required String orderDate,
//     required String appLogoPath,
//   }) async {
//     final pdf = pw.Document();

//     // Load Arabic Font
//     final fontData = await rootBundle.load("assets/fonts/HacenEgypt.ttf");
//     final ttf = pw.Font.ttf(fontData);

//     // Load App Logo
//     final ByteData logoBytes = await rootBundle.load(appLogoPath);
//     final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

//     // Fetch product images
//     final List<pw.MemoryImage?> productImages = await Future.wait(
//       items.map((item) async {
//         try {
//           final response = await http.get(Uri.parse(item.productImage));
//           if (response.statusCode == 200) {
//             return pw.MemoryImage(response.bodyBytes);
//           }
//         } catch (e) {
//           print("Error fetching image: $e");
//         }
//         return null;
//       }),
//     );

//     pdf.addPage(
//       pw.MultiPage(
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: ttf),
//         build: (pw.Context context) => [
//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//               pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text(
//                     "الفاتورة",
//                     style: pw.TextStyle(font: ttf, fontSize: 24, fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.SizedBox(height: 10),
//                   pw.Row(
//                     children: [
//                       pw.Text("رقم الفاتورة: ", style: pw.TextStyle(font: ttf, color: PdfColors.orange)),
//                       pw.Text("$orderNo", style: pw.TextStyle(font: ttf)),
//                     ],
//                   ),
//                   pw.Row(
//                     children: [
//                       pw.Text("تاريخ الفاتورة: ", style: pw.TextStyle(font: ttf, color: PdfColors.orange)),
//                       pw.Text(orderDate, style: pw.TextStyle(font: ttf)),
//                     ],
//                   ),
//                 ],
//               ),
//               pw.Image(logoImage, width: 80),
//             ],
//           ),
//           pw.SizedBox(height: 20),
//           pw.Row(
//             children: [
//               pw.Text("طريقة الدفع: ", style: pw.TextStyle(font: ttf, color: PdfColors.orange)),
//               pw.Text("الدفع عند الاستلام", style: pw.TextStyle(font: ttf)),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//               pw.Row(
//                 children: [
//                   pw.Text("إجمالي الكمية: ", style: pw.TextStyle(font: ttf, color: PdfColors.orange)),
//                   pw.Text("$totalQuantity", style: pw.TextStyle(font: ttf)),
//                 ],
//               ),
//               pw.Row(
//                 children: [
//                   pw.Text("إجمالي الفاتورة: ", style: pw.TextStyle(font: ttf, color: PdfColors.orange)),
//                   pw.Text(totalPrice.toStringAsFixed(2), style: pw.TextStyle(font: ttf)),
//                 ],
//               ),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//               pw.Row(
//                 children: [
//                   pw.Text("الخصم / الإضافة: ", style: pw.TextStyle(font: ttf, color: PdfColors.orange)),
//                   pw.Text("0.000", style: pw.TextStyle(font: ttf)),
//                 ],
//               ),
//               pw.Row(
//                 children: [
//                   pw.Text("السعر النهائي: ", style: pw.TextStyle(font: ttf, color: PdfColors.orange)),
//                   pw.Text(totalPrice.toStringAsFixed(2), style: pw.TextStyle(font: ttf)),
//                 ],
//               ),
//             ],
//           ),
//           pw.SizedBox(height: 30),
//           pw.Text("الأقسام", style: pw.TextStyle(font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.orange, width: 1),
//             columnWidths: {
//               0: const pw.FixedColumnWidth(40),
//               1: const pw.FlexColumnWidth(3),
//               2: const pw.FixedColumnWidth(50),
//               3: const pw.FixedColumnWidth(70),
//               4: const pw.FixedColumnWidth(70),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: const pw.BoxDecoration(color: PdfColors.orange),
//                 children: [
//                   _pdfHeaderCell("رقم", ttf),
//                   _pdfHeaderCell("اسم الصنف", ttf),
//                   _pdfHeaderCell("الكمية", ttf),
//                   _pdfHeaderCell("سعر القطعة", ttf),
//                   _pdfHeaderCell("الإجمالي", ttf),
//                 ],
//               ),
//               ...List.generate(items.length, (index) {
//                 final item = items[index];
//                 final img = productImages[index];
//                 return pw.TableRow(
//                   children: [
//                     _pdfDataCell("${item.number}", ttf),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(5),
//                       child: pw.Row(
//                         children: [
//                           if (img != null) pw.Image(img, width: 20, height: 20),
//                           pw.SizedBox(width: 5),
//                           pw.Expanded(
//                             child: pw.Text(item.productArName, style: pw.TextStyle(font: ttf, fontSize: 10)),
//                           ),
//                         ],
//                       ),
//                     ),
//                     _pdfDataCell("${item.quantity}", ttf),
//                     _pdfDataCell((item.priceAfterDiscount ?? item.price).toStringAsFixed(2), ttf),
//                     _pdfDataCell(((item.priceAfterDiscount ?? item.price) * item.quantity).toStringAsFixed(2), ttf),
//                   ],
//                 );
//               }),
//             ],
//           ),
//         ],
//       ),
//     );

//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdf.save(),
//     );
//   }

//   static pw.Widget _pdfHeaderCell(String text, pw.Font font) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.all(5),
//       child: pw.Text(
//         text,
//         textAlign: pw.TextAlign.center,
//         style: pw.TextStyle(font: font, color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 12),
//       ),
//     );
//   }

//   static pw.Widget _pdfDataCell(String text, pw.Font font) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.all(5),
//       child: pw.Text(
//         text,
//         textAlign: pw.TextAlign.center,
//         style: pw.TextStyle(font: font, fontSize: 10),
//       ),
//     );
//   }
// }
