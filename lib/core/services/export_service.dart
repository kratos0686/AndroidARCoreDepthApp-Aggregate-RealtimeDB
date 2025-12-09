import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xml/xml.dart';

part 'export_service.g.dart';

class ExportService {

  /// Generates a basic ESX (Xactimate) compatible XML file.
  /// Note: The actual ESX schema is proprietary and complex.
  /// This generates a standard "Sketch" XML structure often used for interchange.
  Future<void> exportToXactimate(Map<String, dynamic> roomData) async {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');

    builder.element('XactimateEstimate', nest: () {
      builder.element('ProjectInfo', nest: () {
        builder.element('ProjectName', nest: 'Room Scan Export');
        builder.element('CreatedDate', nest: DateTime.now().toIso8601String());
      });

      builder.element('Rooms', nest: () {
        builder.element('Room', nest: () {
          builder.attribute('Name', roomData['name'] ?? 'Unknown Room');
          builder.element('Dimensions', nest: () {
            builder.element('Length', nest: roomData['length'].toString());
            builder.element('Width', nest: roomData['width'].toString());
            builder.element('Height', nest: roomData['height'].toString());
          });
        });
      });

      builder.element('Notes', nest: () {
        if (roomData['notes'] != null) {
          for (var note in roomData['notes']) {
            builder.element('Note', nest: note.toString());
          }
        }
      });
    });

    final xmlDocument = builder.buildDocument();
    await _saveAndShare(xmlDocument.toXmlString(pretty: true), "scan_export.esx");
  }

  /// Generates a MICA-compatible XML format.
  Future<void> exportToMica(Map<String, dynamic> roomData) async {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');

    builder.element('MICAExchange', nest: () {
      builder.element('LossLocation', nest: () {
        builder.element('Room', nest: () {
           builder.attribute('ID', '1');
           builder.element('Name', nest: roomData['name'] ?? 'Room 1');
           builder.element('Area', nest: _calculateArea(roomData));
        });
      });
    });

    final xmlDocument = builder.buildDocument();
    await _saveAndShare(xmlDocument.toXmlString(pretty: true), "mica_export.xml");
  }

  String _calculateArea(Map<String, dynamic> data) {
    final l = data['length'] as double? ?? 0.0;
    final w = data['width'] as double? ?? 0.0;
    return (l * w).toStringAsFixed(2);
  }

  Future<void> _saveAndShare(String content, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(content);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Sharing export file: $fileName'
      );
    } catch (e) {
      // Handle error in real app
      print("Error sharing file: $e");
    }
  }
}

@riverpod
ExportService exportService(ExportServiceRef ref) {
  return ExportService();
}
