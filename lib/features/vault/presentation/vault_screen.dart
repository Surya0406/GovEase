import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../core/session/session_manager.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/vault_document_model.dart';
import '../services/vault_service.dart';
import 'document_viewer_screen.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  List<VaultDocumentModel> _documents = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'date_desc';

  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['All', 'Identity', 'Education', 'Income', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDocuments() async {
    setState(() {
      _isLoading = true;
    });

    final ownerId = SessionManager.instance.currentUserOwnerId;
    final docs = await VaultService.instance.getDocumentsForOwner(
      ownerId,
      searchQuery: _searchQuery,
      categoryFilter: _selectedCategory,
      sortBy: _sortBy,
    );

    if (!mounted) return;
    setState(() {
      _documents = docs;
      _isLoading = false;
    });
  }

  Future<void> _importDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      );

      if (result == null || result.files.isEmpty || result.files.single.path == null) {
        return;
      }

      final file = File(result.files.single.path!);
      final defaultName = result.files.single.name;

      if (!mounted) return;

      // Prompt for Document Display Name and Category
      String inputName = defaultName;
      String selectedCat = 'Identity';

      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Add Document to Vault'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: inputName,
                      decoration: const InputDecoration(
                        labelText: 'Document Title',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => inputName = val,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCat,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Identity', 'Education', 'Income', 'Other']
                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedCat = val);
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Encrypt & Save'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (confirm != true) return;

      final ownerId = SessionManager.instance.currentUserOwnerId;
      await VaultService.instance.importAndEncryptDocument(
        sourceFile: file,
        displayName: inputName,
        category: selectedCat,
        ownerId: ownerId,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Document encrypted and stored securely in vault!'),
          backgroundColor: Colors.green,
        ),
      );

      _loadDocuments();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to import document: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteDocument(VaultDocumentModel doc) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document?'),
        content: Text('Are you sure you want to permanently delete "${doc.displayName}" from your secure vault?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final ownerId = SessionManager.instance.currentUserOwnerId;
    await VaultService.instance.deleteDocument(ownerId, doc);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document deleted.')),
    );

    _loadDocuments();
  }

  Future<void> _renameDocument(VaultDocumentModel doc) async {
    String newName = doc.displayName;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Document'),
        content: TextFormField(
          initialValue: newName,
          decoration: const InputDecoration(labelText: 'New Title'),
          onChanged: (val) => newName = val,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (confirm != true || newName.trim().isEmpty) return;

    final ownerId = SessionManager.instance.currentUserOwnerId;
    await VaultService.instance.renameDocument(ownerId, doc.docId, newName);

    _loadDocuments();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'My Secure Vault',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (val) {
              setState(() {
                _sortBy = val;
              });
              _loadDocuments();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'date_desc', child: Text('Sort by Date (Newest)')),
              const PopupMenuItem(value: 'date_asc', child: Text('Sort by Date (Oldest)')),
              const PopupMenuItem(value: 'name_asc', child: Text('Sort by Name (A-Z)')),
              const PopupMenuItem(value: 'size_desc', child: Text('Sort by Size (Largest)')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _importDocument,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_moderator),
        label: const Text('Add Document', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Filter Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  _searchQuery = val;
                  _loadDocuments();
                },
                decoration: InputDecoration(
                  hintText: 'Search encrypted documents...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _searchQuery = '';
                            _loadDocuments();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? AppColors.darkCard : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      selectedColor: Colors.blue.shade700,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                        _loadDocuments();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // Documents List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _documents.isEmpty
                      ? _buildEmptyState(isDark)
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: _documents.length,
                          itemBuilder: (context, index) {
                            final doc = _documents[index];
                            return _buildDocumentCard(doc, isDark);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(VaultDocumentModel doc, bool isDark) {
    final sizeMb = (doc.fileSize / (1024 * 1024)).toStringAsFixed(2);
    final ext = doc.fileExtension.toUpperCase();

    IconData fileIcon = Icons.insert_drive_file;
    Color iconColor = Colors.blue;

    if (doc.mimeType.contains('pdf') || ext == 'PDF') {
      fileIcon = Icons.picture_as_pdf;
      iconColor = Colors.red.shade600;
    } else if (['JPG', 'JPEG', 'PNG'].contains(ext)) {
      fileIcon = Icons.image;
      iconColor = Colors.green.shade600;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      color: isDark ? AppColors.darkCard : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: iconColor.withValues(alpha: 0.15),
          child: Icon(fileIcon, color: iconColor),
        ),
        title: Text(
          doc.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  doc.category,
                  style: TextStyle(fontSize: 10, color: Colors.blue.shade800, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '$ext • $sizeMb MB',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (val) {
            if (val == 'open') {
              _openDocument(doc);
            } else if (val == 'rename') {
              _renameDocument(doc);
            } else if (val == 'delete') {
              _deleteDocument(doc);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'open', child: Text('Open Document')),
            const PopupMenuItem(value: 'rename', child: Text('Rename')),
            const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
          ],
        ),
        onTap: () => _openDocument(doc),
      ),
    );
  }

  void _openDocument(VaultDocumentModel doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentViewerScreen(document: doc),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield_outlined, size: 72, color: Colors.blue.shade300),
            const SizedBox(height: 16),
            const Text(
              'Your Vault is Empty',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your government documents (Aadhaar, PAN, Marksheets) for offline, AES-256 encrypted local storage.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _importDocument,
              icon: const Icon(Icons.add_moderator),
              label: const Text('Add Document Now'),
            ),
          ],
        ),
      ),
    );
  }
}
