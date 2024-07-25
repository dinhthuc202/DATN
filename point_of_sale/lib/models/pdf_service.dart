import 'package:flutter/services.dart';
import 'package:number_to_vietnamese_words/number_to_vietnamese_words.dart';
import 'package:point_of_sale/models/customer.dart';
import 'package:point_of_sale/models/purchase.dart';
import 'package:point_of_sale/models/sale.dart';
import 'package:point_of_sale/models/supplier.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../api.dart';
import '../common.dart';

class PdfService {
  Future<Uint8List> printSalePdf(Sale sale) async {
    Customer customer = await Api.getCustomer(customerId: sale.CustomerId!);
    PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    var font = await getFont();

    drawMiddleText('HÓA ĐƠN BÁN HÀNG', page, PdfTrueTypeFont(font, 23), 0);
    DateTime dateTime = DateTime.now();
    drawMiddleText(
        "Ngày ${dateTime.day} tháng ${dateTime.month} năm ${dateTime.year}",
        page,
        PdfTrueTypeFont(font, 12, style: PdfFontStyle.italic),
        25);
    page.graphics.drawString(
      'Tên khách hàng: ${customer.Name ?? ''}',
      PdfTrueTypeFont(font, 14),
      bounds: Rect.fromLTWH(0, 55, pageSize.width, pageSize.height),
    );
    page.graphics.drawString(
      'Địa chỉ: ${customer.Address ?? ""}',
      PdfTrueTypeFont(font, 14),
      bounds: Rect.fromLTWH(0, 75, pageSize.width, pageSize.height),
    );

    //Table
    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 5);
    grid.headers.add(1);

    grid.columns[0].width = 40;
    //grid.columns[1].width = 200;
    grid.columns[2].width = 60;
    grid.columns[3].width = 70;
    grid.columns[4].width = 80;

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = "STT";
    header.cells[1].value = "Tên hàng hóa, dịch vụ";
    header.cells[2].value = "Số lượng";
    header.cells[3].value = "Đơn giá";
    header.cells[4].value = "Thành tiền";

    PdfTrueTypeFont fontHeader =
        PdfTrueTypeFont(font, 12, style: PdfFontStyle.bold);

    PdfGridCellStyle headerStyle = PdfGridCellStyle(
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      ),
      backgroundBrush: PdfBrushes.lightGray,
      //textBrush: PdfBrushes.black,
      font: fontHeader,
    );

    for (var i = 0; i < 5; i++) {
      header.cells[i].style = headerStyle;
    }

    PdfGridCellStyle cellStyle = PdfGridCellStyle(
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      ),
    );

    PdfGridRow row1 = grid.rows.add();
    for (var i = 0; i < 5; i++) {
      row1.cells[i].style = cellStyle;
    }

    row1.cells[0].value = "A";
    row1.cells[1].value = "B";
    row1.cells[2].value = "1";
    row1.cells[3].value = "2";
    row1.cells[4].value = "3=1x2";
    //row1.cells[4].style = PdfGridCellStyle(borders: PdfBorders);

    int count = 0;
    for (final item in sale.saleDetails!) {
      if (item.ItemName == '') {
        var tmp = await Api.getItem(itemId: item.ItemId!);
        item.ItemName = tmp.Name;
      }
      PdfGridRow row = grid.rows.add();
      count = count + 1;
      row.cells[0].style = cellStyle;
      row.cells[2].style = cellStyle;
      row.cells[3].style = cellStyle;
      row.cells[4].style = cellStyle;

      row.cells[0].value = "$count";
      row.cells[1].value = item.ItemName;
      row.cells[2].value = "${item.Quantity}";
      row.cells[3].value = formatMoney(item.Price!);
      row.cells[4].value = formatMoney(item.Quantity!.toDouble() * item.Price!);
    }
    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 5, right: 5, top: 8, bottom: 5),
      font: PdfTrueTypeFont(font, 12),
    );

    PdfLayoutResult gridResult =
        grid.draw(page: page, bounds: const Rect.fromLTWH(0, 100, 0, 0))!;

    page.graphics.drawString(
      'Tổng tiền:',
      PdfTrueTypeFont(font, 14),
      bounds: Rect.fromLTWH(
          0, gridResult.bounds.bottom + 10, pageSize.width, pageSize.height),
    );
    drawRightText(formatMoney(sale.SaleAmount!), page,
        PdfTrueTypeFont(font, 14), gridResult.bounds.bottom + 10, 5);

    page.graphics.drawString(
      "Bằng chữ: ${int.parse(sale.SaleAmount!.toString()).toVietnameseWords()}",
      PdfTrueTypeFont(font, 14),
      bounds: Rect.fromLTWH(
          0, gridResult.bounds.bottom + 29, pageSize.width, pageSize.height),
    );

    List<int> bytes = await document.save();
    //Download document
    // AnchorElement(
    //     href:
    //     "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    //   ..setAttribute("download", "report.pdf")
    //   ..click();
    document.dispose();
    return Uint8List.fromList(bytes);
  }

  Future<Uint8List> printPurchasePdf(Purchase purchase) async {
    Supplier supplier = await Api.getSupplier(supplierId: purchase.SupplierId!);
    PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    var font = await getFont();

    drawMiddleText('HÓA ĐƠN MUA HÀNG', page, PdfTrueTypeFont(font, 23), 0);
    DateTime dateTime = DateTime.now();
    drawMiddleText(
        "Ngày ${dateTime.day} tháng ${dateTime.month} năm ${dateTime.year}",
        page,
        PdfTrueTypeFont(font, 12, style: PdfFontStyle.italic),
        25);
    page.graphics.drawString(
      'Tên nhà cung: ${supplier.Name ?? ''}',
      PdfTrueTypeFont(font, 14),
      bounds: Rect.fromLTWH(0, 55, pageSize.width, pageSize.height),
    );
    page.graphics.drawString(
      'Địa chỉ: ${supplier.Address ?? ""}',
      PdfTrueTypeFont(font, 14),
      bounds: Rect.fromLTWH(0, 75, pageSize.width, pageSize.height),
    );

    //Table
    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 5);
    grid.headers.add(1);
    grid.columns[0].width = 40;
    grid.columns[2].width = 60;
    grid.columns[3].width = 70;
    grid.columns[4].width = 80;

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = "STT";
    header.cells[1].value = "Tên hàng hóa, dịch vụ";
    header.cells[2].value = "Số lượng";
    header.cells[3].value = "Đơn giá";
    header.cells[4].value = "Thành tiền";

    PdfTrueTypeFont fontHeader =
        PdfTrueTypeFont(font, 12, style: PdfFontStyle.bold);

    PdfGridCellStyle headerStyle = PdfGridCellStyle(
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      ),
      backgroundBrush: PdfBrushes.lightGray,
      font: fontHeader,
    );

    for (var i = 0; i < 5; i++) {
      header.cells[i].style = headerStyle;
    }

    PdfGridCellStyle cellStyle = PdfGridCellStyle(
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      ),
    );

    PdfGridRow row1 = grid.rows.add();
    for (var i = 0; i < 5; i++) {
      row1.cells[i].style = cellStyle;
    }

    row1.cells[0].value = "A";
    row1.cells[1].value = "B";
    row1.cells[2].value = "1";
    row1.cells[3].value = "2";
    row1.cells[4].value = "3=1x2";
    //row1.cells[4].style = PdfGridCellStyle(borders: PdfBorders);

    int count = 0;
    for (var item in purchase.purchaseDetails!) {
      if (item.ItemName == '') {
        var tmp = await Api.getItem(itemId: item.ItemId!);
        item.ItemName = tmp.Name;
      }
      PdfGridRow row = grid.rows.add();
      count = count + 1;
      row.cells[0].style = cellStyle;
      row.cells[2].style = cellStyle;
      row.cells[3].style = cellStyle;
      row.cells[4].style = cellStyle;

      row.cells[0].value = "$count";
      row.cells[1].value = item.ItemName;
      row.cells[2].value = "${item.Quantity}";
      row.cells[3].value = formatMoney(item.Price!);
      row.cells[4].value = formatMoney(item.Quantity!.toDouble() * item.Price!);
    }
    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 5, right: 5, top: 8, bottom: 5),
      font: PdfTrueTypeFont(font, 12),
    );

    PdfLayoutResult gridResult =
        grid.draw(page: page, bounds: const Rect.fromLTWH(0, 100, 0, 0))!;

    page.graphics.drawString(
      'Tổng tiền:',
      PdfTrueTypeFont(font, 14),
      bounds: Rect.fromLTWH(
          0, gridResult.bounds.bottom + 10, pageSize.width, pageSize.height),
    );
    drawRightText(formatMoney(purchase.PurchaseAmount!), page,
        PdfTrueTypeFont(font, 14), gridResult.bounds.bottom + 10, 5);

    page.graphics.drawString(
      "Bằng chữ: ${int.parse(purchase.PurchaseAmount!.toString()).toVietnameseWords()}",
      PdfTrueTypeFont(font, 14),
      bounds: Rect.fromLTWH(
          0, gridResult.bounds.bottom + 29, pageSize.width, pageSize.height),
    );

    List<int> bytes = await document.save();
    document.dispose();
    return Uint8List.fromList(bytes);
  }

  void drawMiddleText(String text, PdfPage page, PdfFont font, double top) {
    final Size pageSize = page.getClientSize();
    Size textSize = font.measureString(text);
    final double x = (pageSize.width - textSize.width) / 2;
    page.graphics.drawString(
      text,
      font,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(x, top, textSize.width, textSize.height),
    );
  }

  void drawRightText(
      String text, PdfPage page, PdfFont font, double top, double right) {
    final Size pageSize = page.getClientSize();
    Size textSize = font.measureString(text);
    final double x = pageSize.width - textSize.width - right;
    page.graphics.drawString(
      text,
      font,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(x, top, textSize.width, textSize.height),
    );
  }

  Future<List<int>> getFont() async {
    ByteData fontData =
        await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    List<int> fontBytes = fontData.buffer.asUint8List();
    return fontBytes;
  }
}
