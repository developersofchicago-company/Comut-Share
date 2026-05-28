// Chat service using Supabase Realtime channels.
//
// Each ride has its own channel keyed by ride_id. Subscribers listen for
// INSERT events on chat_messages filtered by ride_id, so each ride is its own
// isolated thread.
//
// Sending is just a plain insert into chat_messages — RLS policies enforce
// that only ride participants (driver + accepted riders) can read/write.

import 'package:supabase_flutter/supabase_flutter.dart';

class ChatMessage {
  final String id;
  final String rideId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  // Joined (optional)
  final String? senderName;

  ChatMessage({
    required this.id,
    required this.rideId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.senderName,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        rideId: json['ride_id'] as String,
        senderId: json['sender_id'] as String,
        text: json['text'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        senderName: json['sender_name'] as String?,
      );
}

class ChatService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch the full message history for a ride.
  Future<List<ChatMessage>> getHistory(String rideId) async {
    final rows = await _supabase
        .from('chat_messages')
        .select('id, ride_id, sender_id, text, created_at')
        .eq('ride_id', rideId)
        .order('created_at', ascending: true);
    return (rows as List<dynamic>)
        .map((r) => ChatMessage.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  /// Send a message in a ride. Returns the inserted row.
  Future<ChatMessage> send(String rideId, String text) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');
    if (text.trim().isEmpty) throw Exception('Empty message');

    final row = await _supabase
        .from('chat_messages')
        .insert({
          'ride_id': rideId,
          'sender_id': userId,
          'text': text.trim(),
        })
        .select('id, ride_id, sender_id, text, created_at')
        .single();

    return ChatMessage.fromJson(row);
  }

  /// Subscribe to new messages on a ride. Caller MUST .unsubscribe() the
  /// returned RealtimeChannel when done.
  RealtimeChannel subscribe(String rideId, void Function(ChatMessage msg) onMessage) {
    final channel = _supabase
        .channel('ride-chat-$rideId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'ride_id',
            value: rideId,
          ),
          callback: (payload) {
            try {
              final msg = ChatMessage.fromJson(payload.newRecord);
              onMessage(msg);
            } catch (_) {
              // ignore malformed payloads
            }
          },
        )
        .subscribe();
    return channel;
  }

  String? get currentUserId => _supabase.auth.currentUser?.id;
}
