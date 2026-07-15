import 'package:flutter/material.dart';
import '../../models/room.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../login_screen.dart';
import 'room_form_screen.dart';

class AdminRoomsScreen extends StatefulWidget {
  const AdminRoomsScreen({super.key});

  @override
  State<AdminRoomsScreen> createState() => _AdminRoomsScreenState();
}

class _AdminRoomsScreenState extends State<AdminRoomsScreen> {
  List<Room> _rooms = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Not logged in');
      final rooms = await ApiService.getRooms(token);
      setState(() {
        _rooms = rooms;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Future<void> _openForm({Room? room}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => RoomFormScreen(room: room),
      ),
    );
    if (result == true) _loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Rooms'),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadRooms),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: Colors.indigo.shade700,
        icon: const Icon(Icons.add),
        label: const Text('Add Room'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadRooms, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_rooms.isEmpty) {
      return const Center(
        child: Text('No rooms yet. Tap + to add one.'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRooms,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          final room = _rooms[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: room.isAvailable
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                child: Icon(
                  Icons.meeting_room,
                  color: room.isAvailable ? Colors.green : Colors.red,
                ),
              ),
              title: Text(room.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('\$${room.price.toStringAsFixed(2)}/night'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatusBadge(status: room.status),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _openForm(room: room),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isAvailable = status == 'available';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isAvailable ? 'Available' : 'Occupied',
        style: TextStyle(
          color: isAvailable ? Colors.green.shade800 : Colors.red.shade800,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
