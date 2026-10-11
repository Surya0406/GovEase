import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../../../core/session/session_manager.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/vault_document_model.dart';
import '../services/vault_service.dart';

class DocumentViewerScreen extends StatefulWidget {
  final VaultDocumentModel document;

  const DocumentViewerScreen({
    super.key,
    required this.document,
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  File? _decryptedFile;

  @override
  void initState() {
    super.initState();
    _decryptAndLoad();
  }

  Future<void> _decryptAndLoad() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ownerId = SessionManager.instance.currentUserOwnerId;
      final tempFile = await VaultService.instance.decryptDocumentToTempFile(
        ownerId,
        widget.document,
      );

      if (!mounted) return;
      setState(() {
        _decryptedFile = tempFile;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  void dispose() {
    // Immediately delete temporary decrypted file on viewer exit
    if (_decryptedFile != null && _decryptedFile!.existsSync()) {
      try {
        _decryptedFile!.deleteSync();
      } catch (_) {}
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          widget.document.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showDocumentDetails,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Decrypting document securely...'),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.security, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          'Decryption Error',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _decryptAndLoad,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              : _buildViewerContent(),
    );
  }

  Widget _buildViewerContent() {
    if (_decryptedFile == null) return const SizedBox();

    final ext = widget.document.fileExtension.toLowerCase();

    if (ext == 'pdf') {
      return PDFView(
        filePath: _decryptedFile!.path,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          setState(() {
            _errorMessage = 'Failed to load PDF: $error';
          });
        },
      );
    } else if (['jpg', 'jpeg', 'png', 'webp'].contains(ext)) {
      return Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.file(_decryptedFile!),
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.insert_drive_file, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              widget.document.displayName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('File format (.${widget.document.fileExtension.toUpperCase()})'),
            const SizedBox(height: 24),
            const Text(
              'Document is decrypted and stored securely in app internal storage.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
  }

  void _showDocumentDetails() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final doc = widget.document;
        final sizeMb = (doc.fileSize / (1024 * 1024)).toStringAsFixed(2);

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doc.displayName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 24),
              _detailRow('Category', doc.category),
              _detailRow('File Extension', doc.fileExtension.toUpperCase()),
              _detailRow('File Size', '$sizeMb MB'),
              _detailRow('Added On', doc.createdAt.substring(0, 10)),
              _detailRow('SHA-256 Hash', '${doc.sha256Hash.substring(0, 16)}...'),
              _detailRow('Encryption', 'AES-256-CBC (Keystore Protected)'),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
